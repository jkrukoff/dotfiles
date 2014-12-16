# .bash_profile

# Get the aliases and functions.
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs.

PATH="$PATH:/usr/local/bin:$HOME/bin"
INPUTRC="$HOME/.inputrc"
BASH_ENV="$HOME/.bashrc"
HISTIGNORE="[   ]*:&:bg:fg"
EDITOR=`which vim`
PIP_DOWNLOAD_CACHE=$HOME/.pip_download_cache

export PATH INPUTRC BASH_ENV HISTIGNORE EDITOR PIP_DOWNLOAD_CACHE

# Golang specific.

GOPATH=$HOME/Documents/go
PATH=$PATH:$GOPATH/bin

export GOPATH PATH

# Aetna development environment settings.

# Only set CDPATH for interactive shells.
if [[ $- == *i* ]]; then
	CDPATH=.:$GOPATH/src/stash.itriagehealth.com
fi
