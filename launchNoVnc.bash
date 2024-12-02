#!/bin/bash

./installNoVnc.bash
export DISPLAY=:0
test -e "$GITPOD_REPO_ROOT" && gp-vncsession
