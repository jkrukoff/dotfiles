#!/bin/bash
# .bashrc

# Shell options.

set -o notify
set -o ignoreeof
#set -o nounset
set -o vi

shopt -s cmdhist
shopt -s checkwinsize
shopt -s histappend
shopt -s hostcomplete
#shopt -s nullglob
shopt -s shift_verbose
shopt -u sourcepath

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

# History variables.

HISTIGNORE="[ 	]*:&:bg:fg"
HISTCONTROL=ignoredups
HISTFILESIZE=0

# External autocomplete.

BASH_AUTOCOMPLETE_DIR=/usr/local/etc/bash_completion.d
source $BASH_AUTOCOMPLETE_DIR/docker
source $BASH_AUTOCOMPLETE_DIR/tmux
source $BASH_AUTOCOMPLETE_DIR/git-completion.bash
source $BASH_AUTOCOMPLETE_DIR/git-prompt.sh

# Prompt variables.

# Provide default column width.
if [ -z "$COLUMNS" ]; then
	COLUMNS=80
fi

# Git prompt variables.
GIT_PS1_SHOWDIRTYSTATE='true'
GIT_PS1_SHOWSTASHSTATE='true'
GIT_PS1_SHOWUPSTREAM='auto'

if tput hs; then
	STATUS_LINE="$(tput tsl)[ \u@\h(\$SHLVL) ]: \$PWD$(tput fsl)"
else
	STATUS_LINE=''
fi

# Use now embedded in LONGDASH.
MVTODASH="$(tput cr)"'$(tput cuf $(( $(tput cols) - ${#DASH} - 1 )) )'
# Used directly in PS1.
MVTOEDGE="$(tput cr)"
CLR_NORM="$(tput sgr0)"
CLR_PUNC="${CLR_NORM}$(tput bold)$(tput setaf 4)$(tput setab 4)"
CLR_TEXT="${CLR_NORM}$(tput setaf 6)$(tput setab 4)"

# Try to make it obvious that I'm root.
if [ "$(whoami)" == "root" ]; then
	CLR_USER="${CLR_NORM}$(tput sgr0)$(tput setaf 1)$(tput setab 4)"
	PATH="/sbin:/usr/sbin:/usr/local/sbin:$PATH"
	export PATH
else
	CLR_USER="$CLR_TEXT"
fi

# Now for the ugly.
OLDCOLUMNS=0
LONGDASH_CACHE=''
LONGDASH='
	if [ "$OLDCOLUMNS" == "$COLUMNS" ]; then
		echo -n "$LONGDASH_CACHE"
	else
		NODASH=$(( 3 * ($COLUMNS / 4) ));
		DASH=$(eval printf ~%.0s {1..$NODASH})
		echo -ne '"$MVTODASH"';
		echo -n "$DASH";
		LONGDASH_CACHE="$DASH";

		unset DASH;
		unset NODASH;
	fi;
'
SHRTDASH_CACHE=''
SHRTDASH='
	if [ "$OLDCOLUMNS" == "$COLUMNS" ]; then
		echo -n "$SHRTDASH_CACHE"
	else
		if [ $COLUMNS -lt 80 ]; then
			DASH="~";
		else
			NODASH=$(( $COLUMNS / 4 ));
			DASH=$(eval printf ~%.0s {1..$NODASH})
		fi;
		echo -n "$DASH";
		SHRTDASH_CACHE="$DASH"

		unset DASH;
		unset NODASH;

		OLDCOLUMNS="$COLUMNS"
	fi;
'

# Time to actually set the prompt!
PS1="$STATUS_LINE$CLR_PUNC\\[\$(eval $LONGDASH)\\]$MVTOEDGE[$CLR_USER\\u@\\h(\$SHLVL) $CLR_TEXT\$(__git_ps1 \"git:%s \")$CLR_PUNC|$CLR_TEXT \\@ \\d$CLR_PUNC]\$(eval $SHRTDASH)$CLR_NORM\\n\\w \\!\\\$ "
PS2='\w \!>'
PS4='+ \!>'

unset SHRTDASH
unset LONGDASH
unset MVTODASH
unset MVTOEDGE
unset CLR_PUNC
unset CLR_TEXT
unset CLR_NORM
unset CLR_USER

# Project management and switching.

if [ -n "$PROJECT" ]; then
	source ~/.bash_project_${PROJECT}
fi

function project {
	local PROJECT="$1"
	local CLR_NORM="$(tput sgr0)"
	local CLR_PUNC="${CLR_NORM}$(tput bold)$(tput setaf 4)$(tput setab 4)"
	local LINE_BREAK="$CLR_PUNC$(eval printf ~%.0s {1..$(( $COLUMNS - 1 ))})$CLR_NORM"

	if [ -r ~/.bash_project_${PROJECT} ]; then
		echo -e "\n\n$LINE_BREAK\n$(tput setaf 2)Switching to project: $PROJECT$CLR_NORM\n$LINE_BREAK\n\n"
		PROJECT="$PROJECT" bash
	else
		echo "$(tput setaf 1)No project file for: $PROJECT"
	fi
}
