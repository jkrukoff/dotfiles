#!/bin/bash

source ~/.projects/lib.bash
cd_project ~/Documents/Rally\ Ripper

postgres -D /usr/local/var/postgres &
source /virtualenv/bin/activate
