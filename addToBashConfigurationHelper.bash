#!/bin/bash

addToBashConfiguration() {
    echo $1 >> ~/.bashrc
    source ~/.bashrc
}
