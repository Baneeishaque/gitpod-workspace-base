#!/bin/bash

source ./remoteDebInstallHelper.bash

installLatestDebFromGithub() {

    ./installJq.bash

    local repository=$1
    local api_url="https://api.github.com/repos/$repository/releases/latest"
    local download_url=$(curl -s $api_url | jq -r '.assets[] | select(.name | endswith(".deb")) | .browser_download_url')
    installRemoteDeb $download_url
}
