#!/bin/bash

source ~/.projects/lib.bash
cd_project ~/Documents/Riptide/tf-infra
tags

activate_awsume
eval "$(awsume riptide -s)"
