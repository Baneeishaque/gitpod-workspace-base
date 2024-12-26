#!/bin/bash

installRemoteDeb() {
    local downloadUrl=$1
    wget $downloadUrl
    local installationFile=$(basename $downloadUrl)
    ./updatePackageIndex.bash
    sudo apt install -y ./$installationFile
    rm $installationFile
}
