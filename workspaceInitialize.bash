#!/bin/bash

append_to_bashrc() {
    local var_name=$1
    local var_value=$2

    if ! grep -Fxq "export $var_name=$var_value" ~/.bashrc; then
        if grep -Fq "$var_name=" ~/.bashrc; then
            echo "Variable $var_name is already set with a different value in ~/.bashrc. Not overwriting."
        else
            echo "export $var_name=$var_value" >> ~/.bashrc
        fi
    fi
}

script_dir="$(dirname "$(realpath "$0")")" &&
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
        append_to_bashrc GH_TOKEN "$GH_TOKEN"
        if [ -v GETGIST_USER ]; then
            append_to_bashrc GETGIST_USER "$GETGIST_USER"
            append_to_bashrc GETGIST_TOKEN "$GH_TOKEN"
        fi
    fi &&
    if [ -v GITLAB_TOKEN ]; then
        append_to_bashrc GITLAB_TOKEN "$GITLAB_TOKEN"
        append_to_bashrc GITLAB_ACCESS_TOKEN "$GITLAB_TOKEN"
        append_to_bashrc OAUTH_TOKEN "$GITLAB_TOKEN"
    fi &&
    if [ -v DOCKER_HUB_USERNAME ] && [ -v DOCKER_HUB_PASSWORD ]; then
        append_to_bashrc DOCKER_HUB_USERNAME "$DOCKER_HUB_USERNAME"
        append_to_bashrc DOCKER_HUB_PASSWORD "$DOCKER_HUB_PASSWORD"
        docker login --username "$DOCKER_HUB_USERNAME" --password "$DOCKER_HUB_PASSWORD"
    fi &&
    if [ -v AZURE_DEVOPS_EXT_PAT ]; then
        append_to_bashrc AZURE_DEVOPS_EXT_PAT "$AZURE_DEVOPS_EXT_PAT"
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
    cd "$script_dir" &&
    if [ -f ./copyConfigurations.bash ]; then
        ./copyConfigurations.bash
        if [ $? -eq 0 ]; then
            if [ -f /workspace/configurations-private/.gitconfig ]; then
                rm -f ~/.gitconfig
                ln -s /workspace/configurations-private/.gitconfig ~/.gitconfig
                if [ -f ~/.gitconfig ]; then
                    echo "Link to .gitconfig created successfully."
                else
                    echo "Error: ~/.gitconfig is not a file after linking."
                fi
            else
                echo "Error: .gitconfig does not exist in /workspace/configurations-private."
            fi
        else
            echo "Error: copyConfigurations.bash did not run successfully."
        fi
    else
        echo "Error: copyConfigurations.bash does not exist."
    fi &&
    source ~/.bashrc
