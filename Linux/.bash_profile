#!/bin/bash
# .bash_profile

# User specific environment and startup programs.

export PATH="$PATH:/usr/local/bin:$HOME/bin:$HOME/.local/bin"
export INPUTRC="$HOME/.inputrc"
export BASH_ENV="$HOME/.bashrc"
export EDITOR=`which vim`
export CLICOLOR=true

# Development environment variables.

export VIRTUAL_ENV_DISABLE_PROMPT=yes
export VAGRANT_HOME=/data/jkrukoff/.vagrant.d
export GOPATH="$HOME/Documents/go"
export PATH="$PATH:$GOPATH/bin"
export VAULT_ADDR="https://vault.svc.ubnt.com:8200"

# Get the aliases and functions.
if [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi
