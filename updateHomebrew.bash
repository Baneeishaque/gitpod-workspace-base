#!/bin/bash

echo "Updating Homebrew..."
if ! brew update; then
    echo "Error: Homebrew update failed."
    exit 1
fi

echo "Homebrew updated successfully."
exit 0
