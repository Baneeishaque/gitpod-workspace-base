#!/bin/bash

VERSION_ID=$(sudo grep -oP 'VERSION_ID="\K[^"]+' /etc/os-release)
wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb
./updatePackageIndex.bash
sudo apt install -y ./packages-microsoft-prod.deb
./updatePackageIndex.bash
sudo apt install -y powershell
rm packages-microsoft-prod.deb
