#!/bin/bash

source ~/.projects/lib.bash
cd_project llists git@github.com:jkrukoff/llists.git
tags

exec poetry shell
