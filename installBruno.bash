#!/bin/bash

source ./remoteDebInstallHelper.bash

installRemoteDeb "https://github.com$(curl -s https://github.com/usebruno/bruno/releases | grep -oP 'href="\/usebruno\/bruno\/releases\/download\/v[\d\.]+\/bruno_[\d\.]+_amd64_linux\.deb' | sed 's/href="//')"
