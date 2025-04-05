#!/bin/bash

source ./brewFormulaInstallHelper.bash
source ./addToBashConfigurationHelper.bash

installBrewFormula mise

addToBashConfiguration 'eval "$(mise activate bash)"'
