#!/bin/bash

source ~/.projects/lib.bash
cd_project ~/Documents/UBIC/push-notifications-server

source ~/.kerl/releases/20.0/activate

export ERL_AFLAGS="-kernel shell_history enabled"
export RELX_REPLACE_OS_VARS=true

# Jenkins tokens for manual deployment.
export DEPLOY_TOKEN_DEV=???
export DEPLOY_TOKEN_STG=???
export DEPLOY_TOKEN_PRD=???

# Scary production configuration values for testing.
export SNS_REGION="us-west-1"
export SNS_ACCESS_KEY_ID=???
export SNS_SECRET_ACCESS_KEY=???

# Default DEV configuration values for testing.
export AWS_REGION="us-west-2"
export AWS_ACCESS_KEY_ID=???
export AWS_SECRET_ACCESS_KEY=???
export SQS_INGEST_QUEUE=???
export MANDRILL_API_KEY=???
