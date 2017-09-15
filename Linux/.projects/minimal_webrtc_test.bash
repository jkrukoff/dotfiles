#!/bin/bash

source ~/.projects/lib.bash
cd_project ~/Documents/Minimal\ WebRTC\ Test
tags

export NVM_DIR=~/.nvm
source "${NVM_DIR}/nvm.sh"
nvm use 0.10
export PATH="$(npm bin):${PATH}"

npm install bower grunt-cli

eval "$(rbenv init -)"
rbenv local 2.2.3
