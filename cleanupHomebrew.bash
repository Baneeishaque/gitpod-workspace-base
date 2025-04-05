#!/bin/bash

echo "Running brew autoremove..."
if ! brew autoremove; then
    echo "Error: brew autoremove failed."
    exit 1
fi

echo "Running brew cleanup..."
if ! brew cleanup; then
    echo "Error: brew cleanup failed."
    exit 1
fi
