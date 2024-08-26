eval $(gp env -e) &&
    if [ -v BASH_HUB_ACCESS_TOKEN ] && [ -v BASH_HUB_SYSTEM_NAME ]; then
        bashHubConfigurationFolder=$HOME/.bashhub &&
            if [ ! -d $bashHubConfigurationFolder ]; then
                mkdir $bashHubConfigurationFolder
            fi &&
            bashHubConfigurationPath=$bashHubConfigurationFolder/config &&
            printf "[bashhub]\naccess_token = $(echo $BASH_HUB_ACCESS_TOKEN)\nsystem_name = $(echo $BASH_HUB_SYSTEM_NAME)" >$bashHubConfigurationPath &&
            cd /workspace &&
            curl -OL https://bashhub.com/setup &&
            sed -z 's+\n        if ! ../env/bin/bashhub util update_system_info; then\n            # Run setup if we run into any issues updating our system info\n            ../env/bin/bashhub setup\n        fi++' -i setup &&
            bash setup &&
            rm setup
    fi &&
    if [ -v GH_TOKEN ]; then
        echo "export GH_TOKEN=$(echo $GH_TOKEN)" >>~/.bashrc
    fi &&
    if [ -v GH_TOKEN ] && [ -v GETGIST_USER ]; then
        echo "export GETGIST_TOKEN=$(echo $GH_TOKEN)" >>~/.bashrc &&
            echo "export GETGIST_USER=$(echo $GETGIST_USER)" >>~/.bashrc
    fi &&
    if [ -v GITLAB_TOKEN ]; then
        echo "export GITLAB_TOKEN=$(echo $GITLAB_TOKEN)" >>~/.bashrc
    fi &&
    if [ -v DOCKER_HUB_USERNAME ] && [ -v DOCKER_HUB_PASSWORD ]; then
        echo "export DOCKER_HUB_USERNAME=$(echo $DOCKER_HUB_USERNAME)" >>~/.bashrc &&
            echo "export DOCKER_HUB_PASSWORD=$(echo $DOCKER_HUB_PASSWORD)" >>~/.bashrc &&
            docker login --username $(echo $DOCKER_HUB_USERNAME) --password $(echo $DOCKER_HUB_PASSWORD)
    fi &&
    if [ ! -d vscode-insider-user-data ]; then
        mkdir vscode-insider-user-data
    fi &&
    vscodeInsiderUserData="$HOME/.config/Code - Insiders" &&
    if [ ! -h "$vscodeInsiderUserData" ]; then
        ln -s vscode-insider-user-data "$vscodeInsiderUserData"
    fi &&
    vscodeUserFolder=~/.vscode-insiders &&
    if [ ! -d $vscodeUserFolder ]; then
        mkdir $vscodeUserFolder
    fi &&
    if [ ! -d vscode-insider-extensions ]; then
        mkdir vscode-insider-extensions
    fi &&
    vscodeUserExtensionsFolder=$vscodeUserFolder/extensions &&
    if [ ! -h $vscodeUserExtensionsFolder ]; then
        ln -s vscode-insider-extensions $vscodeUserExtensionsFolder
    fi &&
    if [ ! -d downloads ]; then
        mkdir downloads
    fi &&
    userDownloadsFolder="$HOME/Downloads" &&
    if [ ! -h "$userDownloadsFolder" ]; then
        ln -s downloads "$userDownloadsFolder"
    fi &&
    if [ -d configurations-private ]; then
        cd configurations-private &&
            git stash &&
            git pull &&
            cd ..
    else
        if [ -v CONFIGURATION_REPOSITORY_URL ]; then
            git clone $(echo $CONFIGURATION_REPOSITORY_URL)
        fi
    fi &&
    # if [ -v EDGE_CONFIGURATION_REPOSITORY_URL ]; then
    #     if [ -d microsoft-edge-config-private ]; then
    #         cd microsoft-edge-config-private &&
    #             git pull &&
    #             cd ..
    #     else
    #         git clone $(echo $EDGE_CONFIGURATION_REPOSITORY_URL)
    #     fi &&
    #         rm -rf ~/.config/microsoft-edge-dev &&
    #         ln -s microsoft-edge-config-private/microsoft-edge-dev ~/.config/microsoft-edge-dev
    # fi &&
    if [ ! -d Periodic-Mouse-Click-Chrome-Selenium-Python ]; then
        git clone https://github.com/Baneeishaque/Periodic-Mouse-Click-Chrome-Selenium-Python.git
    fi &&
    cd Periodic-Mouse-Click-Chrome-Selenium-Python &&
    git pull &&
    pyenv install --skip-existing &&
    pip install -r requirements.txt &&
    cd .. &&
    if [ ! -d Android/Sdk ]; then
        brew install pup &&
        androidCommandLineToolsLinuxDownloadUrl="https://dl.google.com/android/repository/$(wget -O - "https://developer.android.com/studio#command-tools" | pup '[data-modal-dialog-id="sdk_linux_download"] text{}')" &&
            wget $androidCommandLineToolsLinuxDownloadUrl &&
            androidCommandLineToolsArchieve=$(basename $androidCommandLineToolsLinuxDownloadUrl) &&
            unzip $androidCommandLineToolsArchieve &&
            mkdir -p Android/Sdk/cmdline-tools/latest &&
            mv cmdline-tools/* Android/Sdk/cmdline-tools/latest/ &&
            rmdir cmdline-tools/ &&
            rm $androidCommandLineToolsArchieve &&
            yes | /workspace/Android/Sdk/cmdline-tools/latest/bin/sdkmanager --licenses
    fi &&
    if [ -d fvm/versions/master ]; then
        cd fvm/versions/master &&
            git pull &&
            cd /workspace
    fi &&
    . /home/gitpod/.sdkman/bin/sdkman-init.sh &&
    sdk use java $(sdk list java | grep "local only" | grep "17" | awk '{print $NF}') &&
    # fvm install stable &&
    # fvm install beta &&
    fvm install master &&
    # fvm global master &&
    # very_good --version &&
    # very_good update &&
    fvm spawn master create my_app &&
    cd my_app &&
    fvm spawn master build bundle &&
    fvm spawn master build apk &&
    fvm spawn master build appbundle &&
    fvm spawn master build linux &&
    fvm spawn master build web &&
    cd .. &&
    rm -rf my_app &&
    fvm spawn master create my_module --template=module &&
    cd my_module &&
    fvm spawn master build aar &&
    cd .. &&
    rm -rf my_module &&
    source ~/.bashrc &&
    cd configurations-private &&
    git stash pop &&
    cd ..
