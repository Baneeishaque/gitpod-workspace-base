phpMyAdminInstallFolder=/opt/phpMyAdmin-english
if [ ! -d $phpMyAdminInstallFolder ]; then
    brew install pup
    phpMyAdminDownloadUrl=$(wget -O - https://www.phpmyadmin.net/downloads | pup 'a.download_popup attr{href}' | grep --max-count=1 'english.zip')
    wget $phpMyAdminDownloadUrl
    phpMyAdminArchieveFile=$(basename $phpMyAdminDownloadUrl)
    sudo unzip $phpMyAdminArchieveFile -d /opt/
    rm $phpMyAdminArchieveFile
    phpMyAdminFolder=$(echo $phpMyAdminArchieveFile | sed 's/\(.*\)\..*/\1/')
    sudo mv /opt/$phpMyAdminFolder $phpMyAdminInstallFolder
    sudo cp $phpMyAdminInstallFolder/config.sample.inc.php $phpMyAdminInstallFolder/config.inc.php
    printf "\n\$cfg['AllowArbitraryServer'] = true;" | sudo tee -a $phpMyAdminInstallFolder/config.inc.php >/dev/null
fi
