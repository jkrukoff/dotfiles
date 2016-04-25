#!/bin/bash

source ~/.projects/lib.bash
cd_project ~/Documents/UBIC/app-unifi-sdn

export PATH="$(npm bin):${PATH}"
eval "$(rbenv init -)"
