#!/bin/bash
# .bash_profile

# User specific environment and startup programs.

export PATH="$PATH:/usr/local/bin:$HOME/bin"
export INPUTRC="$HOME/.inputrc"
export BASH_ENV="$HOME/.bashrc"
export EDITOR=`which vim`
export CLICOLOR=true

# Development environment variables.

export GOPATH=$HOME/Documents/go
export PATH=$PATH:$GOPATH/bin

# Get the aliases and functions.
if [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi
