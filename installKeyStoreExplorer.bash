keyExplorerDownloadUrl="https://github.com/kaikramer/keystore-explorer/releases/download/v5.5.1/kse_5.5.1_all.deb"
wget $keyExplorerDownloadUrl
keyExplorerInstallationFile=$(basename $keyExplorerDownloadUrl)
./updatePackageIndex.bash
sudo apt install -y ./$keyExplorerInstallationFile
rm $keyExplorerInstallationFile
