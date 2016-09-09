#!/bin/bash

source ~/.projects/lib.bash
cd_project ~/Documents/UBIC/app-unifi-sdn

export NVM_DIR=~/.nvm
source "${NVM_DIR}/nvm.sh"
nvm use 0.10
export PATH="$(npm bin):${PATH}"

eval "$(rbenv init -)"
rbenv local 2.2.3
