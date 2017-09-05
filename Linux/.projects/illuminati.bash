#!/bin/bash

source ~/.projects/lib.bash
cd_project ~/Documents/Operations/illuminati
activate_virtualenv

export INFLUX_USERNAME=???
export INFLUX_PASSWORD=???

function influx.inf {
  influx -host influxdb.svc.ubnt.com -ssl
}
