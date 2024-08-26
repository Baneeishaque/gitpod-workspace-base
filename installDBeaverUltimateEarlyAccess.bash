dBeaverDownloadPageUrl="https://dbeaver.com/files/ea/ultimate"
brew install pup
dBeaverDownloadUrl=$(echo $dBeaverDownloadPageUrl/$(wget -O - $dBeaverDownloadPageUrl | pup 'table.s3_listing_files tbody tr td a attr{href}' | grep '.deb'))
wget $dBeaverDownloadUrl
dBeaverInstallationFile=$(basename $dBeaverDownloadUrl)
./updatePackageIndex.bash
sudo apt install -y ./$dBeaverInstallationFile
rm $dBeaverInstallationFile
