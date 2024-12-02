#!/bin/bash

./updateHomebrew.bash
brew tap leoafarias/fvm
brew install leoafarias/fvm/fvm
./cleanupHomebrew.bash
