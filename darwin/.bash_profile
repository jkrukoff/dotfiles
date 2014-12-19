# .bash_profile

# System functions.

BASH_AUTOCOMPLETE_DIR=/usr/local/etc/bash_completion.d
source $BASH_AUTOCOMPLETE_DIR/docker
source $BASH_AUTOCOMPLETE_DIR/tmux
source $BASH_AUTOCOMPLETE_DIR/git-completion.bash
source $BASH_AUTOCOMPLETE_DIR/git-prompt.sh

# Get the aliases and functions.
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs.

PATH="$PATH:/usr/local/bin:$HOME/bin"
INPUTRC="$HOME/.inputrc"
BASH_ENV="$HOME/.bashrc"
HISTIGNORE="[ 	]*:&:bg:fg"
EDITOR=`which vim`
# HOMEBREW_GITHUB_API_TOKEN=<secret>

export PATH INPUTRC BASH_ENV HISTIGNORE EDITOR

# Development environment variables.

PIP_DOWNLOAD_CACHE=$HOME/.pip_download_cache
JAVA_HOME=`/usr/libexec/java_home -v 1.8`
GOPATH=$HOME/Documents/go
PATH=$PATH:$GOPATH/bin

export PIP_DOWNLOAD_CACHE JAVA_HOME GOPATH

# Aetna development environment settings.

# Only set CDPATH for interactive shells.
if [[ $- == *i* ]]; then
	CDPATH=.:$GOPATH/src/stash.itriagehealth.com
fi
