#!/bin/bash
source ~/.projects/lib.bash
PROJECT_PATH=~/Documents/mc-web
cd_project "$PROJECT_PATH"
npm install
export PATH="$PATH:$PROJECT_PATH/node_modules/.bin"

