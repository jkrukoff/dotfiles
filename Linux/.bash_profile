#!/bin/bash
# ~/.bash_profile

# User specific environment and startup programs.
export PATH="${PATH}:/usr/local/bin:${HOME}/bin:${HOME}/.local/bin"
export INPUTRC="${HOME}/.inputrc"
export BASH_ENV="${HOME}/.bashrc"
EDITOR="$(which vim)"
export EDITOR
export CLICOLOR=true

# Development environment variables.
export VIRTUAL_ENV_DISABLE_PROMPT=yes
export VAGRANT_HOME=/data/jkrukoff/.vagrant.d
export GOPATH="${HOME}/Documents/go"
export PATH="${PATH}:${GOPATH}/bin"

# Secrets.

# Get the aliases and functions.
if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi
