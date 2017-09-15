#!/bin/bash

source ~/.projects/lib.bash
cd_project ~/Documents/UBIC/ubic
tags

source ~/.kerl/releases/R16B02/activate
activate_virtualenv .

function start-db {
  docker-compose up
}

function reset-db {
  EXTRA_PG="-h localhost" make postgres-drop
  EXTRA_PG="-h localhost" make postgres-init
}

function run-tests {
  make clean-adoption-data
  make test
}
