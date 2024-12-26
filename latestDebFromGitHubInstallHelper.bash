#!/bin/bash

source ./remoteDebInstallHelper.bash

installLatestDebFromGithub() {
    local repository=$1
    local searchTerm=$2
    installRemoteDeb "https://github.com$(curl -s https://github.com/$repository/releases | grep -oP 'href="\/'$repository'\/releases\/download\/v[\d\.]+\/'$searchTerm'\.deb' | sed 's/href="//')"
}
