eval $(gp env -e)
bashHubConfigurationFolder=$HOME/.bashhub &&
    mkdir $bashHubConfigurationFolder &&
    bashHubConfigurationPath=$bashHubConfigurationFolder/config &&
    printf "[bashhub]\naccess_token = $(echo $BASH_HUB_ACCESS_TOKEN)\nsystem_name = $(echo $BASH_HUB_SYSTEM_NAME)" >$bashHubConfigurationPath &&
    cd /workspace &&
    curl -OL https://bashhub.com/setup &&
    sed -z 's+\n        if ! ../env/bin/bashhub util update_system_info; then\n            # Run setup if we run into any issues updating our system info\n            ../env/bin/bashhub setup\n        fi++' -i setup &&
    bash setup &&
    rm setup &&
    echo "export GH_TOKEN=$(echo $GH_TOKEN)" >>~/.bashrc &&
    echo "export GETGIST_TOKEN=$(echo $GH_TOKEN)" >>~/.bashrc &&
    echo "export GETGIST_USER=$(echo $GETGIST_USER)" >>~/.bashrc &&
    echo "export DOCKER_HUB_USERNAME=$(echo $DOCKER_HUB_USERNAME)" >>~/.bashrc &&
    echo "export DOCKER_HUB_PASSWORD=$(echo $DOCKER_HUB_PASSWORD)" >>~/.bashrc &&
    docker login --username $(echo $DOCKER_HUB_USERNAME) --password $(echo $DOCKER_HUB_PASSWORD) &&
    rm -rf $(pwd)/microsoft-edge-config-private/ &&
    git clone $(echo $EDGE_CONFIGURATION_REPOSITORY_URL) &&
    rm -rf ~/.config/microsoft-edge-dev &&
    ln -s $(pwd)/microsoft-edge-config-private/microsoft-edge-dev ~/.config/microsoft-edge-dev &&
    androidCommandLineToolsLinuxDownloadUrl="https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip" &&
    cd /workspace &&
    wget $androidCommandLineToolsLinuxDownloadUrl &&
    androidCommandLineToolsArchieve=$(basename $androidCommandLineToolsLinuxDownloadUrl) &&
    unzip $androidCommandLineToolsArchieve &&
    mkdir -p Android/Sdk/cmdline-tools/latest &&
    mv cmdline-tools/* Android/Sdk/cmdline-tools/latest/ &&
    rmdir cmdline-tools/ &&
    rm $androidCommandLineToolsArchieve &&
    export ANDROID_HOME="/workspace/Android/Sdk" &&
    # fvm install stable &&
    # fvm install beta &&
    fvm install master &&
    fvm global master &&
    cd /workspace &&
    flutter create my_app &&
    cd my_app &&
    flutter build bundle &&
    flutter build apk &&
    flutter build appbundle &&
    flutter build linux &&
    flutter build web &&
    cd .. &&
    rm -rf my_app &&
    flutter create my_module --template=module &&
    cd my_module &&
    flutter build aar &&
    cd .. &&
    rm -rf my_module &&
    mkdir /workspace/vscode-insider-user-data &&
    ln -s /workspace/vscode-insider-user-data "$HOME/.config/Code - Insiders" &&
    mkdir ~/.vscode-insiders &&
    mkdir /workspace/vscode-insider-extensions &&
    ln -s /workspace/vscode-insider-extensions ~/.vscode-insiders/extensions &&
    exit
