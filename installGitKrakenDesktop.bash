gitKrakenDownloadUrl="https://release.gitkraken.com/linux/gitkraken-amd64.deb"
wget $gitKrakenDownloadUrl
gitKrakenInstallationFile=$(basename $gitKrakenDownloadUrl)
./updatePackageIndex.bash
sudo apt install -y ./$gitKrakenInstallationFile
rm $gitKrakenInstallationFile
