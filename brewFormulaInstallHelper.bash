#!/bin/bash

installBrewFormula() {
    local formula=$1
    ./updateHomebrew.bash
    brew install $formula
    ./cleanupHomebrew.bash
}
