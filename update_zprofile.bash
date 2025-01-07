#!/bin/bash

update_zprofile() {
    var_name=$1
    var_value=$2

    # Check if .zprofile or .zshrc exists and update or append the variable
    if [ -f ~/.zprofile ]; then
        if grep -q "export $var_name=" ~/.zprofile; then
            sed -i "" "s|export $var_name=.*|export $var_name=$var_value|g" ~/.zprofile
        else
            echo "export $var_name=$var_value" >> ~/.zprofile
        fi
    else
        if grep -q "export $var_name=" ~/.zshrc; then
            sed -i "" "s|export $var_name=.*|export $var_name=$var_value|g" ~/.zshrc
        else
            echo "export $var_name=$var_value" >> ~/.zshrc
        fi
    fi
}
