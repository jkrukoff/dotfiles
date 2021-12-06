#!/bin/bash
# .bash_profile

# Get the aliases and functions.
if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

# User specific environment and startup programs.

export PATH="$PATH:/usr/local/bin:$HOME/bin"
export INPUTRC="$HOME/.inputrc"
export BASH_ENV="$HOME/.bashrc"
export EDITOR=$(which vim)
export CLICOLOR=true
#export HOMEBREW_GITHUB_API_TOKEN=

# Development environment variables.

export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
export GOPATH=$HOME/Documents/go
export PATH=$PATH:$GOPATH/bin

# Nix package manager.

if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
  source ~/.nix-profile/etc/profile.d/nix.sh
fi
