#!/bin/bash

source ./addToBashConfigurationHelper.bash

installBrewFormula() {
    local formula=$1
    ./updateHomebrew.bash
    brew install $formula
    ./cleanupHomebrew.bash
}

installBrewFormulaAfterSystemAppRemoval() {
    local systemAppPath=$(which $1)
    if [ -n "$systemAppPath" ]; then
        if [ -f "$systemAppPath" ]; then
            echo "Found existing $1 at $systemAppPath. Renaming it for backup."
            sudo mv "$systemAppPath" "$systemAppPath.bak"
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
