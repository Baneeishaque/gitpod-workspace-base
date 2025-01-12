#!/bin/bash

visualStudioCodeInsidersInstallationFile=visualStudioCodeInsiders.deb
wget --output-document=$visualStudioCodeInsidersInstallationFile "https://code.visualstudio.com/sha/download?build=insider&os=linux-deb-x64"
./updatePackageIndex.bash
sudo apt install -y ./$visualStudioCodeInsidersInstallationFile
rm $visualStudioCodeInsidersInstallationFile
