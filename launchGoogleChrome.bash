#!/bin/bash

eval $(gp env -e)

./installGoogleChrome.bash

cd /workspace

chromeConfigurationFolder=chrome-config
if [ -d $chromeConfigurationFolder ]; then
    cd $chromeConfigurationFolder
    git pull
else
    if [ -v GOOGLE_CHROME_CONFIGURATION_HOME_REPO ]; then
        git clone --depth 1 $(echo $GOOGLE_CHROME_CONFIGURATION_HOME_REPO) $chromeConfigurationFolder
    fi
fi

export CHROME_CONFIG_HOME=$(pwd)/$chromeConfigurationFolder && google-chrome
