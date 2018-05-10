#!/bin/bash

source ~/.projects/lib.bash
cd_project ~/Documents/Riptide/tf-aws-secops
tags

activate_awsume
eval "$(awsume riptide -s)"
