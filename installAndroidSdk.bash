source ./installAndroidSdkComponents.bash

if [ ! -d /workspace/Android/Sdk ]; then
    ./updateHomebrew.bash
    brew install pup
    ./cleanupHomebrew.bash
    cd /workspace
    androidCommandLineToolsLinuxDownloadUrl="https://dl.google.com/android/repository/$(wget -O - "https://developer.android.com/studio#command-tools" | pup '[data-modal-dialog-id="sdk_linux_download"] text{}')"
    wget $androidCommandLineToolsLinuxDownloadUrl
    androidCommandLineToolsArchieve=$(basename $androidCommandLineToolsLinuxDownloadUrl)
    unzip $androidCommandLineToolsArchieve
    mkdir -p Android/Sdk/cmdline-tools/latest
    mv cmdline-tools/* Android/Sdk/cmdline-tools/latest/
    rmdir cmdline-tools/
    rm $androidCommandLineToolsArchieve
    yes | /workspace/Android/Sdk/cmdline-tools/latest/bin/sdkmanager --licenses
fi

# Check if java is available
if command -v java &>/dev/null; then
    # Check if sdkmanager is available
    if command -v sdkmanager &>/dev/null; then
        install_android_components
    else
        echo "sdkmanager not found."
    fi
else
    echo "java not found."
fi
