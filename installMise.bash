#!/bin/bash

source ./brewFormulaInstallHelper.bash

installBrewFormula mise

echo 'eval "$(mise activate bash)"' >> ~/.bashrc
