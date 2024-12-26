#!/bin/bash

installBrewFormula() {
    ./updateHomebrew.bash
    brew install $1
    ./cleanupHomebrew.bash
}
