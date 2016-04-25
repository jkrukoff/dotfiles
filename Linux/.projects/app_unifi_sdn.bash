#!/bin/bash

source ~/.projects/lib.bash
cd_project ~/Documents/UBIC/app-unifi-sdn

export PATH="~/.rbenv/bin:$(npm bin):node${PATH}"
eval "$(rbenv init -)"
