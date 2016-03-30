#!/bin/bash
# .bashrc

# Pull in system defaults.
if [ -f /etc/bash.bashrc ]; then
	source /etc/bash.bashrc
fi

if [ -f /etc/skel/.bashrc ]; then
	source /etc/skel/.bashrc
fi

# Shell options. Only set for interactive shell, leave default options for
# scripts.
case "$-" in
	*i*)
		# Interactive shell.
		set -o notify
		set -o ignoreeof
		#set -o nounset
		set -o vi

		shopt -s checkwinsize
		shopt -s cmdhist
		shopt -s dirspell
		shopt -s histappend
		shopt -s hostcomplete
		#shopt -s nullglob
		shopt -s globstar
		shopt -s shift_verbose
		shopt -u sourcepath
	;;
	*)
		# Non-interactive shell.
	;;
esac

# Aliases.

alias cd..='cd ..'
alias df='df -h'
alias du='du -h'
alias la='ls -a'
alias ll='ls -l'
alias ls='ls -b -F'
alias lsd='ls -d */'
alias md='mkdir'
alias rd='rmdir'
alias pstree='pstree -g3'
alias tree='tree -FA'
alias info='info --vi-keys'
alias have='which -s'
alias hl='source-highlight --failsafe -f esc256 -n -i'

# External functions.

source ~/bin/z.sh

# History variables.

HISTIGNORE="[ 	]*:&:bg:fg"
HISTCONTROL=ignoredups
HISTFILESIZE=0

# Prompt variables.

# Provide default column width.
if [ -z "$COLUMNS" ]; then
	COLUMNS=80
fi

# Git prompt variables.
GIT_PS1_SHOWDIRTYSTATE='true'
GIT_PS1_SHOWSTASHSTATE='true'
GIT_PS1_SHOWUPSTREAM='auto'

# Common color codes.
PROMPT_COLOR_NORM="$(tput sgr0)"
PROMPT_COLOR_PUNC="$PROMPT_COLOR_NORM$(tput bold)$(tput setaf 4)$(tput setab 4)"
PROMPT_COLOR_TEXT="$PROMPT_COLOR_NORM$(tput setaf 6)$(tput setab 4)"
PROMPT_COLOR_USER="$PROMPT_COLOR_TEXT"
PROMPT_COLOR_DIRSTATUS="$PROMPT_COLOR_NORM$(tput sgr0)$(tput setaf 5)$(tput setab 4)"
PROMPT_COLOR_ROOT="$PROMPT_COLOR_NORM$(tput sgr0)$(tput setaf 1)$(tput setab 4)"
PROMPT_COLOR_OK="$PROMPT_COLOR_NORM$(tput setaf 2)"
PROMPT_COLOR_ERR="$PROMPT_COLOR_NORM$(tput setaf 1)$(tput setab 0)"

function dashed_line {
	local DASH=$(eval printf ~%.0s {1..$1});

	if [ "$2" = "right" ]; then
		# Right justify.
		local MVTOEDGE="$(tput cr)"
		local MVTODASH="${MVTOEDGE}$(tput cuf $(( $(tput cols) - ${#DASH} - 1 )) )"
		echo -n "${MVTOEDGE}${MVTODASH}${DASH}"
	else
		# Left justify
		echo -n "$DASH"
	fi
}

function prompt_virtualenv {
	# Check if I've activated a python virtualenv.
	if [ -n "$VIRTUAL_ENV" ]; then
		local version="$(python --version)"
		echo "venv:${version#* }"
	fi
}

function prompt {
	# Set status line for terminals that support it.
	local STATUS_LINE
	if tput hs; then
		STATUS_LINE="$(tput tsl)[ \u@\h(\$SHLVL) ]: \$PWD$(tput fsl)"
	fi

	# Try to make it obvious that I'm root.
	local COLOR_USER="$PROMPT_COLOR_USER"
	if [ "$(whoami)" == "root" ]; then
		COLOR_USER="$PROMPT_COLOR_ROOT"
		export PATH="/sbin:/usr/sbin:/usr/local/sbin:$PATH"
	fi

	local MVTOEDGE="$(tput cr)"
	local LONGDASH='dashed_line $COLUMNS left'
	local INFOBLOCK="[${COLOR_USER}\\u@\\h(\$SHLVL) ${PROMPT_COLOR_DIRSTATUS}\$(__git_ps1 \"git:%s \")\$(prompt_virtualenv)${PROMPT_COLOR_PUNC}|${PROMPT_COLOR_TEXT} \\@ \\d${PROMPT_COLOR_PUNC}]"

	# Time to actually set the prompt!
	PS1="${STATUS_LINE}${PROMPT_COLOR_PUNC}\\[\$(eval ${LONGDASH})\\]${MVTOEDGE}${INFOBLOCK}${PROMPT_COLOR_NORM}\\n\\w \\!\\\$ "
	PS2='\w \!>'
	PS4='+ \!>'
}

prompt

# Project management and switching.

function project {
	local PROJECT="$@"
	PROJECT=${PROJECT// /_}
	PROJECT=${PROJECT//-/_}

	function dashed_line_colored {
		echo -n "${PROMPT_COLOR_PUNC}"
		dashed_line $COLUMNS left
		echo -n "${PROMPT_COLOR_NORM}"
	}

	local PROJECT_FILE=~/".projects/${PROJECT}.bash"

	if [ -r "$PROJECT_FILE" ]; then
		echo -ne '\n\n'
		dashed_line_colored
		echo "${PROMPT_COLOR_OK}Switching to project: $PROJECT"
		dashed_line_colored
		echo -ne '\n\n'
		bash --init-file <(echo "source ~/.bashrc && source \"$PROJECT_FILE\"")
	else
		echo "${PROMPT_COLOR_ERR}No project file for: $PROJECT"
	fi
}

# Track user login/out activity.

TRACK_WHO=""
function track_who {
	local WHO="$(who | cut -d ' ' -f 1 | sort -u)"
	if [ "$WHO" != "$TRACK_WHO" ]; then
		comm <(echo "$TRACK_WHO") <(echo "$WHO")
	fi
	TRACK_WHO="$WHO"
}
