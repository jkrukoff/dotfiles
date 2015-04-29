#!/bin/bash

source ~/.projects/lib.bash

# Configure RVM requirements.
export PATH="$PATH:$HOME/.rvm/bin"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
rvm use 2.2.1

cd_project ~/Documents/Utopia\ Tutorial
