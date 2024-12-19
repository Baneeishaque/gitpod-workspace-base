#!/bin/bash

# Install jq if not already installed
if ! command -v jq &>/dev/null; then
    brew install jq
fi

# Identify the OS and set the URL accordingly
os=$(uname -s | tr '[:upper:]' '[:lower:]')
if [[ "$os" == "darwin" ]]; then
    json_url="https://storage.googleapis.com/flutter_infra_release/releases/releases_macos.json"
else
    json_url="https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json"
fi

# Fetch the JSON data
json_data=$(curl -s "$json_url")

# Extract valid versions from the JSON data
valid_versions=$(echo "$json_data" | jq -r '.releases[].version')

# Set the user_version variable
user_version=${1:-master}

# Validate the user_version if it's not "master"
if [[ "$user_version" != "master" ]]; then
    if ! echo "$valid_versions" | grep -qw "$user_version"; then
        echo "Error: The version '$user_version' is not a valid fvm version."
        echo "Please use one of the following versions:"
        echo "$valid_versions" | tr ' ' '\n'
        exit 1
    fi
fi

SOURCE=${BASH_SOURCE[0]}
while [ -L "$SOURCE" ]; do
  DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
  SOURCE=$(readlink "$SOURCE")
  [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE
done
DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

# Source sdkman initialization script
if [ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]; then
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

./installFVM.bash

sudo apt install -y curl git unzip xz-utils zip libglu1-mesa

# Navigate to the workspace directory
cd /workspace
if [ -d "fvm/versions/$user_version" ]; then
    cd "fvm/versions/$user_version"
    git pull
    cd /workspace
else
    # fvm install stable
    # fvm install beta
    fvm install "$user_version"
    # fvm global master
fi

# Ensure hxselect is installed
if ! command -v hxselect &>/dev/null; then
    sudo apt install -y html-xml-utils
fi

# Extract the current Gradle version from the gradle-wrapper.properties file
gradleVersion=$(grep 'distributionUrl' "fvm/versions/$user_version/examples/hello_world/android/gradle/wrapper/gradle-wrapper.properties" | cut -d'=' -f2 | cut -d'-' -f2)
echo "Gradle Version: $gradleVersion"

table=$(curl -s https://docs.gradle.org/current/userguide/compatibility.html | hxnormalize -x 2>/dev/null | hxselect 'table.tableblock.frame-all.grid-all.stretch tbody')

count=$(echo "$table" | hxselect 'tr' | hxcount | grep -w "tr" | awk '{print $1}')
declare -A gradle_java_map

for ((i = 1; i <= count; i++)); do
    row=$(echo "$table" | hxnormalize -x | hxselect "tr:nth-child($i)")
    # Skip empty rows
    if [ -z "$row" ]; then
        continue
    fi

    java_version=$(echo "$row" | hxnormalize -x | hxselect 'td:first-child p' | grep -oP '(?<=>)[^<]+' | head -n 1)
    gradle_version=$(echo "$row" | hxnormalize -x | hxselect 'td:nth-child(3) p' | grep -oP '(?<=>)[^<]+' | head -n 1)

    # Skip processing if gradle_version is N/A or java_version is less than 8.0
    if [[ "$gradle_version" == "N/A" ]] || [[ $(awk 'BEGIN {print ('"$java_version"' < 8.0)}') -eq 1 ]]; then
        continue
    fi

    if [[ -n $java_version && -n $gradle_version ]]; then
        gradle_java_map["$gradle_version"]="$java_version"
    fi
done

# Store key-value pairs in an array
sorted_output=()
for gradle_ver in "${!gradle_java_map[@]}"; do
    sorted_output+=("$gradle_ver ${gradle_java_map[$gradle_ver]}")
done

# Sort the array in ascending order
IFS=$'\n' sorted_output=($(sort -V <<<"${sorted_output[*]}"))
unset IFS

# Print the sorted array
echo ""
echo "Gradle-Java Compatibility Table (sorted by Gradle version):"
for entry in "${sorted_output[@]}"; do
    gradle_ver=$(echo $entry | awk '{print $1}')
    java_ver=$(echo $entry | awk '{print $2}')
    echo "Gradle $gradle_ver -> Java $java_ver"
done

# Determine Java version for the current Gradle version
java_version="Unknown"
largest_gradle_version=$(echo ${sorted_output[-1]} | awk '{print $1}')

if (($(awk 'BEGIN {print ('"$gradleVersion"' >= '"$largest_gradle_version"') }'))); then
    java_version=$(echo ${sorted_output[-1]} | awk '{print $2}')
else
    for ((j = 0; j < ${#sorted_output[@]}; j++)); do
        current_gradle=$(echo ${sorted_output[$j]} | awk '{print $1}')
        next_gradle=$(echo ${sorted_output[$((j + 1))]} | awk '{print $1}')

        if (($(awk 'BEGIN {print ('"$gradleVersion"' >= '"$current_gradle"' && '"$gradleVersion"' < '"$next_gradle"') }'))); then
            java_version=$(echo ${sorted_output[$j]} | awk '{print $2}')
            break
        fi
    done
fi

echo ""
echo "Required Java Version for Gradle $gradleVersion: $java_version"

# Check if the required Java version is available locally
local_java_version=$(sdk list java | grep "local only" | grep -E "^${java_version}\b" | awk '{print $NF}')

if [[ -n "$local_java_version" ]]; then
    echo "Using local Java version: $local_java_version"
    sdk use java "$local_java_version"
else
    # Define priority order
    priorities=("oracle" "open" "tem" "zulu")

    # Find the largest version matching the required java_version
    available_java_versions=$(sdk list java | grep -E "^\s*.*\b${java_version}\b(\.[0-9]+)*\b" | awk '{print $NF}')

    # Process available versions and remove any version whose major version is not the specified java_version
    processed_java_versions=()
    for version in $available_java_versions; do
        major_version=$(echo "$version" | cut -d'.' -f1)
        if [[ "$major_version" == "$java_version" ]]; then
            processed_java_versions+=("$version")
        fi
    done

    # Print processed versions
    echo "Processed Java Versions:"
    for version in "${processed_java_versions[@]}"; do
        echo "$version"
    done

    # Check for available Java versions in priority order
    selected_java_version=""
    for priority in "${priorities[@]}"; do
        for version in "${processed_java_versions[@]}"; do
            if [[ "$version" == *"$priority"* ]]; then
                selected_java_version=$version
                break 2
            fi
        done
    done

    # If no version found in priority order, use the largest available version
    if [[ -z "$selected_java_version" ]]; then
        selected_java_version=$(echo "${processed_java_versions[@]}" | tr ' ' '\n' | sort -V | tail -n 1)
    fi

    echo "Installing Java version: $selected_java_version"
    sdk install java "$selected_java_version" -y
    sdk use java "$selected_java_version"
fi

. $DIR/installAndroidSdk.bash

fvm spawn "$user_version" create my_app
cd my_app
fvm spawn "$user_version" build bundle
fvm spawn "$user_version" build apk
fvm spawn "$user_version" build appbundle

sudo apt update
sudo apt install -y \
      clang cmake git \
      ninja-build pkg-config \
      libgtk-3-dev liblzma-dev \
      libstdc++-12-dev

fvm spawn "$user_version" build linux
fvm spawn "$user_version" build web
cd ..
rm -rf my_app

fvm spawn "$user_version" create my_module --template=module
cd my_module
fvm spawn "$user_version" build aar
cd ..
rm -rf my_module
