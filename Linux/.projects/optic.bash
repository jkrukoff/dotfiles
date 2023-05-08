#!/bin/bash

source ~/.projects/lib.bash
cd_project optic git@github.com:jkrukoff/optic.git
tags

exec poetry shell
