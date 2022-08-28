FROM gitpod/workspace-full-vnc
ARG phpMyAdminDownloadUrl=https://files.phpmyadmin.net/phpMyAdmin/5.2.0/phpMyAdmin-5.2.0-all-languages.zip
ARG workDirectory=/workspace
WORKDIR $workDirectory
RUN \
#  pwd \
 wget ${phpMyAdminDownloadUrl} \
#  && ls -a $workDirectory \
 && phpMyAdminArchieveFile=$(basename ${phpMyAdminDownloadUrl}) \
#  && echo $phpMyAdminArchieveFile \
 && unzip $phpMyAdminArchieveFile \
#  && ls -a $workDirectory \
 && rm $phpMyAdminArchieveFile \
#  && ls -a $workDirectory \
 && phpMyAdminFolder=$(echo $phpMyAdminArchieveFile | sed 's/\(.*\)\..*/\1/') \
#  && ls -a $workDirectory/$phpMyAdminFolder \
 && cp $phpMyAdminFolder/config.sample.inc.php $phpMyAdminFolder/config.inc.php \
#  && ls -a $workDirectory/$phpMyAdminFolder \
 && printf "\n\$cfg['AllowArbitraryServer'] = true;" >> $phpMyAdminFolder/config.inc.php \
#  && ls -a $workDirectory \
#  && cat $phpMyAdminFolder/config.inc.php