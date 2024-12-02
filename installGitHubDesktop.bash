#!/bin/bash

wget -qO - https://apt.packages.shiftkey.dev/gpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/shiftkey-packages.gpg > /dev/null
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/shiftkey-packages.gpg] https://apt.packages.shiftkey.dev/ubuntu/ any main" | sudo tee /etc/apt/sources.list.d/shiftkey-packages.list > /dev/null
./updatePackageIndex.bash
sudo apt install -y github-desktop
