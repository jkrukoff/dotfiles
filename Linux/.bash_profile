#!/bin/bash
# ~/.bash_profile

# User specific environment and startup programs.
export PATH="${PATH}:/usr/local/bin:${HOME}/bin:${HOME}/.local/bin"
export INPUTRC="${HOME}/.inputrc"
export BASH_ENV="${HOME}/.bashrc"
EDITOR="$(command -v vim)"
export EDITOR
export CLICOLOR=true

# Development environment variables.
for PROJECTS_PATH in "/mnt/x" "${HOME}/local" "${HOME}/Documents"; do
  if [ -d "${PROJECTS_PATH}" ]; then
    break
  fi
done
export PROJECTS_PATH
export GOPATH="${HOME}/Documents/go"
export PATH="${PATH}:${GOPATH}/bin"
export KUBECONFIG="${KUBECONFIG}:${HOME}/.kube/config"
export VAGRANT_HOME="${HOME}/.vagrant.d"
export VIRTUAL_ENV_DISABLE_PROMPT=yes
export PIPENV_DONT_USE_PYENV=yes
export AWS_RETRY_MODE=standard
export ERL_AFLAGS="+pc unicode -enable-feature maybe_expr -kernel shell_history enabled"

# Secrets.
# export GITHUB_TOKEN=""
# export GITHUB_ORGANIZATION=""

# asdf version manager setup.
source ~/.asdf/asdf.sh
source ~/.asdf/completions/asdf.bash

# Get the aliases and functions.
if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi
