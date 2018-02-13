#!/bin/bash

source ~/.projects/lib.bash
cd_project ~/Documents/UBIC/push-notifications-client
tags erltags &

activate_kerl ~/.kerl/releases/R16B02
activate_virtualenv

export ERL_AFLAGS='+pc unicode -kernel shell_history enabled'
export RELX_REPLACE_OS_VARS='true'

# Default DEV configuration values for testing.
export AWS_REGION='...'
export AWS_ACCESS_KEY_ID='...'
export AWS_SECRET_ACCESS_KEY='...'
export SQS_INGEST_QUEUE='...'
export S3_IMAGES_BUCKET='...'

function attach.local {
	erl -sname console -hidden -setcookie push_notifications -remsh "push_notifications@$(hostname)"
}

function observer.local {
	erl -sname observer -hidden -setcookie push_notifications -run observer
}
