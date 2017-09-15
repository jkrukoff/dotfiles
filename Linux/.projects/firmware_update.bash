#!/bin/bash

source ~/.projects/lib.bash
cd_project ~/Documents/Services/firmware-update
tags
activate_virtualenv

function firmware-update-up {
  docker-compose up --build
}

function firmware-update-down {
  docker-compose down -v
}

function firmware-update-mysql {
  mysql --host=127.0.0.1 --port=3306 --user=root --password=my-secret-pw firmware_update
}
