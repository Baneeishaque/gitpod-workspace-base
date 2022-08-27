FROM gitpod/workspace-full-vnc
WORKDIR /workspace
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.2.0/phpMyAdmin-5.2.0-all-languages.zip \
 && unzip phpMyAdmin-5.2.0-all-languages.zip \
 && rm phpMyAdmin-5.2.0-all-languages.zip \
 && cp phpMyAdmin-5.2.0-all-languages/config.sample.inc.php phpMyAdmin-5.2.0-all-languages/config.inc.php \
 && printf "\n$cfg['AllowArbitraryServer'] = true;" >> phpMyAdmin-5.2.0-all-languages/config.inc.php