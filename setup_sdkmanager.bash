#!/bin/bash

source ./update_zprofile.bash
source ./installAndroidSdkComponents.bash

setup_sdkmanager() {
    # Function to set ANDROID_HOME and make it permanent
    set_android_home() {
        sdkmanager_path=$(readlink -f $(command -v sdkmanager))
        android_home=$(dirname $(dirname $(dirname $(dirname $sdkmanager_path))))
        echo "Setting ANDROID_HOME to $android_home"

        # Set ANDROID_HOME environment variable
        export ANDROID_HOME=$android_home

        # Make it permanent
        update_zprofile "ANDROID_HOME" "$android_home"
    }

    # Function to set JAVA_HOME temporarily
    set_java_home() {
        studio_path=$(readlink -f $(command -v studio-canary))
        java_home=$(dirname "$(dirname "$studio_path")")/jbr/Contents/Home
        echo "Setting JAVA_HOME to $java_home"

        # Set JAVA_HOME environment variable
        export JAVA_HOME=$java_home
    }

    # Install Android Studio Canary if not installed
    install_android_studio() {
        if ! command -v studio-canary &>/dev/null; then
            echo "Android Studio not found. Installing Canary version from Homebrew..."
            brew install --cask android-studio-preview@canary
        fi
        set_java_home
    }

    # Enable signing licenses
    enable_licenses() {
        fvm spawn "$user_version" doctor --android-licenses
    }

    # Check if sdkmanager is available
    if command -v sdkmanager &>/dev/null; then
        set_android_home
        install_android_studio
        enable_licenses
        install_android_components
    else
        echo "sdkmanager not found."

        if [[ "$os" == "darwin" ]]; then
            ensure_homebrew

            # Install android-commandlinetools via Homebrew
            echo "Installing android-commandlinetools..."
            brew install --cask android-commandlinetools

            set_android_home
            install_android_studio
            enable_licenses
            install_android_components
        fi
    fi
}
