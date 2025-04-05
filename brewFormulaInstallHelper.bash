#!/bin/bash

source ./addToBashConfigurationHelper.bash

installBrewFormula() {
    if [ -z "$1" ]; then
        echo "Error: No formula name provided."
        return 1
    fi

    echo "Updating Homebrew..."
    if ! ./updateHomebrew.bash; then
        echo "Error: Homebrew update failed."
        return 1
    fi

    echo "Installing formula $1..."
    if ! brew install "$1"; then
        echo "Error: Formula installation failed."
        return 1
    fi

    echo "Cleaning up Homebrew..."
    if ! ./cleanupHomebrew.bash; then
        echo "Error: Homebrew cleanup failed."
        return 1
    fi

    echo "Formula $1 installed successfully."
    return 0
}

installBrewFormulaAfterSystemAppRemoval() {
    if [ -z "$1" ]; then
        echo "Error: No formula name provided."
        return 1
    fi

    local systemAppPath=$(which $1)
    if [ -n "$systemAppPath" ]; then
        if [ -f "$systemAppPath" ]; then
            echo "Found existing $1 at $systemAppPath. Renaming it for backup."
            sudo mv "$systemAppPath" "$systemAppPath.bak"
            if [ $? -ne 0 ]; then
                echo "Error: Failed to rename $systemAppPath for backup."
                return 1
            fi
        else
            echo "Error: $systemAppPath is not a file."
            return 1
        fi
    else
        echo "No existing $1 found. Proceeding with installation."
    fi
    installBrewFormula $1
}

installBrewFormulaWithBashConfigurations() {
    if [ -z "$1" ]; then
        echo "Error: No formula name provided."
        return 1
    fi

    if [ -z "$2" ]; then
        echo "Error: No configuration to add."
        return 1
    fi

    if installBrewFormula "$1"; then
        addToBashConfiguration "$2"
    else
        echo "Installation of $1 failed. Skipping configuration update."
        return 1
    fi
}
