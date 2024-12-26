#!/bin/bash

source ./remoteDebInstallHelper.bash

./updateHomebrew.bash
brew install pup
./cleanupHomebrew.bash

dBeaverDownloadPageUrl="https://dbeaver.com/files/ea/ultimate"
installRemoteDeb $(echo $dBeaverDownloadPageUrl/$(wget -O - $dBeaverDownloadPageUrl | pup 'table.s3_listing_files tbody tr td a attr{href}' | grep '.deb'))
