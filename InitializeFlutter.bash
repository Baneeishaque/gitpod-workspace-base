#!/bin/bash

source ./ensure_homebrew.bash
source ./update_zprofile.bash
source ./setupSdkManager.bash

user_version=${1:-master}

fvm spawn "$user_version" create my_app

cd my_app

# Check if the OS is Ubuntu
os=$(uname -s | tr '[:upper:]' '[:lower:]')
if [[ "$os" == "linux" && -f /etc/lsb-release ]]; then
    . /etc/lsb-release
    if [[ "$DISTRIB_ID" == "Ubuntu" ]]; then
        sudo apt update
        sudo apt install -y \
              clang cmake git \
              ninja-build pkg-config \
              libgtk-3-dev liblzma-dev \
              libstdc++-12-dev

        fvm spawn "$user_version" build linux
    fi
fi

# Check if the OS is macOS
if [[ "$os" == "darwin" ]]; then
    processor=$(uname -m)

    # Install Rosetta if the processor is Apple M1 and Rosetta is not already installed
    if [[ "$processor" == "arm64" ]]; then
        if /usr/sbin/softwareupdate --install-rosetta --agree-to-license > /dev/null 2>&1; then
            echo "Rosetta is already installed."
        else
            echo "Installing Rosetta..."
            /usr/sbin/softwareupdate --install-rosetta --agree-to-license
        fi
    fi

    ensure_homebrew

    # Install Xcode from Apple's official source if it's not installed
    if ! xcode-select -p &>/dev/null; then
        echo "Xcode is not installed. Installing Xcode from Apple's official source..."
        open -a "App Store" || open -a "Software Update"
        sudo xcodebuild -license accept
    fi

    # Install CocoaPods if it's not installed
    if ! command -v pod &>/dev/null; then
        echo "CocoaPods is not installed. Installing CocoaPods..."
        brew install cocoapods
    fi

    fvm spawn "$user_version" build macos

    # Setup sdkmanager
    setup_sdkmanager

    # Source the .zprofile to apply changes
    if [ -f ~/.zprofile ]; then
        source ~/.zprofile
    elif [ -f ~/.zshrc ]; then
        source ~/.zshrc
    fi
fi

# Run the build commands
fvm spawn "$user_version" build bundle
fvm spawn "$user_version" build apk
fvm spawn "$user_version" build appbundle

fvm spawn "$user_version" build web
cd ..
rm -rf my_app

fvm spawn "$user_version" create my_module --template=module
cd my_module
fvm spawn "$user_version" build aar
cd ..
rm -rf my_module
