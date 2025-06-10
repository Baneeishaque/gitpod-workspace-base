#!/bin/bash

eval $(gp env -e)

cd /workspace
if [ -d configurations-private ]; then
    cd configurations-private
        git stash
        git fetch
        git pull
        git stash pop
        cd ..
else
    if [ -v CONFIGURATION_REPOSITORY_URL ]; then
        git clone $(echo $CONFIGURATION_REPOSITORY_URL)
    fi
fi

cd /workspace
if [ -d configurations ]; then
    cd configurations
        git stash
        git pull
        git stash pop
        cd ..
else
    if [ -v PUBLIC_CONFIGURATION_REPOSITORY_URL ]; then
        git clone $(echo $PUBLIC_CONFIGURATION_REPOSITORY_URL)
    fi
fi
