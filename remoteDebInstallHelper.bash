#!/bin/bash

installRemoteDeb() {
    local downloadUrl=$1
    local installationFile="package.deb"
    
    wget -O "$installationFile" "$downloadUrl"
    ./updatePackageIndex.bash
    sudo apt install -y "./$installationFile"
    rm "$installationFile"
}
