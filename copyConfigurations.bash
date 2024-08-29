cd /workspace
if [ -d configurations-private ]; then
    cd configurations-private
        git stash
        git pull
        git stash pop
        cd ..
else
    if [ -v CONFIGURATION_REPOSITORY_URL ]; then
        git clone $(echo $CONFIGURATION_REPOSITORY_URL)
    fi
fi