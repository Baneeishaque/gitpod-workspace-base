#!/bin/bash

addToBashConfiguration() {
    if [ -z "$1" ]; then
        echo "Error: No configuration to add provided."
        return 1
    fi

    echo "Adding configuration to ~/.bashrc..."
    if ! echo "$1" >> ~/.bashrc; then
        echo "Error: Failed to add configuration to ~/.bashrc."
        return 1
    fi

    echo "Sourcing ~/.bashrc..."
    if ! source ~/.bashrc; then
        echo "Error: Failed to source ~/.bashrc."
        return 1
    fi

    echo "Configuration added successfully."
    return 0
}
