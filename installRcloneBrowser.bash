#!/bin/bash

./installRcloneBeta.bash
./updatePackageIndex.bash
sudo apt install -y rclone-browser
