#!/bin/bash

source ./brewFormulaInstallHelper.bash

if ! command -v jq &>/dev/null; then
    installBrewFormula install jq
fi
