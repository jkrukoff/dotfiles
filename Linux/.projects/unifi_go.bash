#!/bin/bash

source ~/.projects/lib.bash
cd_project ~/Documents/Services/unifi-go
tags
activate_gcloud
activate_virtualenv

export FLASK_APP=unifi_go.app
export UNIFI_GO_SETTINGS_FILE=../config/local.json
export GCLOUD_KEYFILE_JSON=~/.config/gcloud/credentials
export INFLUX_USERNAME=???
export INFLUX_PASSWORD=???

function start-db {
  docker-compose up mysql
}

function mysql.local {
  mysql --host=127.0.0.1 --user=??? --password=??? ??? "$@"
}

function mysql.dev {
  mysql --host=??? --user=??? --password=??? ??? "$@"
}

function mysql.stg {
  mysql --host=??? --user=??? --password=??? ??? "$@"
}

function mysql.prd {
  mysql --host=??? --user=??? --password=??? ??? "$@"
}

function kubectl.dev {
  kubectl --cluster="gke_indigo-medium-133523_us-central1-b_dev-usc1b-unifi-go" "$@"
}

function kubectl.stg {
  kubectl --cluster="gke_indigo-medium-133523_us-central1-b_stg-usc1b-unifi-go" "$@"
}

function kubectl.prd {
  kubectl --cluster="gke_indigo-medium-133523_us-central1-b_prd-usc1b-unifi-go" "$@"
}

function influx.inf {
  influx -host influxdb.svc.ubnt.com -ssl
}
