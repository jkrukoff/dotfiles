#!/bin/bash

source ~/.projects/lib.bash
cd_project ~/Documents/Operations/ubnt_terraform
tags

function terraform.ubnt-cleanup {
  kill "${SSH_AGENT_PID}"
  rm /aws/credentials
  sudo rmdir /aws
}

function terraform.ubnt {(
  set -euo pipefail
  (
    cd "${PROJECT_PATH}"
    git fetch
    if ! git merge-base --is-ancestor origin/master HEAD; then
      print_error "Unmerged changes on master."
      exit 1
    fi
  )

  trap 'terraform.ubnt-cleanup' EXIT

  sudo mkdir -p /aws
  sudo chown jkrukoff:jkrukoff /aws
  ln -st /aws ~/.aws/credentials
  eval "$(ssh-agent)"
  ssh-add ~/.ssh/*.pem

  terraform get && terraform "$@"
)}
