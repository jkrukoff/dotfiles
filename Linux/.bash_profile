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
export GOPATH="${HOME}/Documents/go"
export PATH="${PATH}:${GOPATH}/bin:${HOME}/.rbenv/bin"
export KUBECONFIG="${KUBECONFIG}:${HOME}/.kube/config"
export VAGRANT_HOME=/data/jkrukoff/.vagrant.d
export VIRTUAL_ENV_DISABLE_PROMPT=yes

# Secrets.
# export GITHUB_TOKEN=""  # Personal token.
export GITHUB_ORGANIZATION="carbonblack"

# Get the aliases and functions.
if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi
