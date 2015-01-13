#!/bin/bash
# .bash_profile

# Get the aliases and functions.
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs.

export PATH="$PATH:/usr/local/bin:$HOME/bin"
export INPUTRC="$HOME/.inputrc"
export BASH_ENV="$HOME/.bashrc"
export EDITOR=`which vim`
#export HOMEBREW_GITHUB_API_TOKEN=

# Development environment variables.

export PIP_DOWNLOAD_CACHE=$HOME/.pip_download_cache
export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
export GOPATH=$HOME/Documents/go
export PATH=$PATH:$GOPATH/bin
