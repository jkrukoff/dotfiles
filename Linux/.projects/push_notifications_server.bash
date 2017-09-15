#!/bin/bash

source ~/.projects/lib.bash
cd_project ~/Documents/UBIC/push-notifications-server
tags erltags &

source ~/.kerl/releases/20.0/activate

export ERL_AFLAGS="-kernel shell_history enabled"
export RELX_REPLACE_OS_VARS=true

# Jenkins tokens for manual deployment.
export DEPLOY_TOKEN_DEV=???
export DEPLOY_TOKEN_STG=???
export DEPLOY_TOKEN_PRD=???

# Scary production configuration values for testing.
export SNS_REGION=???
export SNS_ACCESS_KEY_ID=???
export SNS_SECRET_ACCESS_KEY=???

# Default DEV configuration values for testing.
export AWS_REGION=???
export AWS_ACCESS_KEY_ID=???
export AWS_SECRET_ACCESS_KEY=???
export SQS_INGEST_QUEUE=???
export MANDRILL_API_KEY=???
export GRAPHITE_PREFIX=???
export GRAPHITE_HOST=???

function attach.local {
	erl -sname console -hidden -setcookie push_notifications -remsh "push_notifications@$(hostname)"
}

function observer.local {
	erl -sname observer -hidden -setcookie push_notifications -run observer
}
