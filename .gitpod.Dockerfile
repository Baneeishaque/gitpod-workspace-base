FROM gitpod/workspace-full-vnc

ENV TIGERVNC_GEOMETRY=1846x968 

ARG phpMyAdminDownloadUrl=https://files.phpmyadmin.net/phpMyAdmin/5.2.0/phpMyAdmin-5.2.0-all-languages.zip
RUN \
#  pwd \
 wget ${phpMyAdminDownloadUrl} \
#  && ls -a $(pwd) \
 && phpMyAdminArchieveFile=$(basename ${phpMyAdminDownloadUrl}) \
#  && echo $phpMyAdminArchieveFile \
 && sudo unzip $phpMyAdminArchieveFile -d /opt/ \
#  && ls -a /opt/ \
 && rm $phpMyAdminArchieveFile \
#  && ls -a $(pwd) \
 && phpMyAdminFolder=$(echo $phpMyAdminArchieveFile | sed 's/\(.*\)\..*/\1/') \
#  && ls -a /opt/$phpMyAdminFolder \
 && sudo cp /opt/$phpMyAdminFolder/config.sample.inc.php /opt/$phpMyAdminFolder/config.inc.php \
#  && ls -a /opt/$phpMyAdminFolder \
 && printf "\n\$cfg['AllowArbitraryServer'] = true;" | sudo tee -a /opt/$phpMyAdminFolder/config.inc.php >/dev/null \
#  && cat /opt/$phpMyAdminFolder/config.inc.php