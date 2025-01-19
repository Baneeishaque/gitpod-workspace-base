#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <ppa-name>"
  exit 1
fi

sudo add-apt-repository -y "$1"

./updatePackageIndex.bash
