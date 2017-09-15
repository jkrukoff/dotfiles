#!/bin/bash

source ~/.projects/lib.bash
cd_project ~/Documents/Operations/graphite
tags

export INFLUX_USERNAME=???
export INFLUX_PASSWORD=???
export KAPACITOR_URL=https://kapacitor.svc.ubnt.com:9092

function influx.inf {
  influx -host ??? -ssl
}