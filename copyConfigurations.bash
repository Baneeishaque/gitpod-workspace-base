#!/bin/bash

eval $(gp env -e)

cd /workspace
if [ -d configurations-private ]; then
    cd configurations-private
        git stash
        git fetch
        git pull
        if ! git rev-parse --verify Gitpod >/dev/null 2>&1; then
            git checkout -b Gitpod origin/Gitpod
        else
            git checkout Gitpod
        fi
        git stash pop
        cd ..
else
    if [ -v CONFIGURATION_REPOSITORY_URL ]; then
        git clone $(echo $CONFIGURATION_REPOSITORY_URL)
        cd configurations-private
        git checkout -b Gitpod origin/Gitpod
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
