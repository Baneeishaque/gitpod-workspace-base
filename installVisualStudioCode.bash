visualStudioCodeInstallationFile=visualStudioCode.deb
wget --output-document=$visualStudioCodeInstallationFile "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
./updatePackageIndex.bash
sudo apt install -y ./$visualStudioCodeInstallationFile
rm $visualStudioCodeInstallationFile
