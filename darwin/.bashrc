# .bashrc

# Provide default column width
if [ -z "$COLUMNS" ]; then
	COLUMNS=80
fi

# Shell Options

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

# Aliases

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

# History variables

HISTCONTROL=ignoredups
HISTFILESIZE=0

# Git prompt variables
GIT_PS1_SHOWDIRTYSTATE='true'
GIT_PS1_SHOWSTASHSTATE='true'
GIT_PS1_SHOWUPSTREAM='auto'

# Prompt variables
case "$TERM" in
	xterm*)
		PROMPT_COMMAND='echo -ne "\033]0;[ $( whoami )@$HOSTNAME ]: $PWD\007"'
	;;
	*)
		PROMPT_COMMAND=''
	;;
esac

# Try not to spew too much garbage on unknown terminals
case "$TERM" in
	vt*|linux|xterm*)
		# Use now embedded in LONGDASH
		MVTODASH='\e[300C\033[$[ $( echo -n $DASH | wc -c ) ]D'
		# Used in PS1
		MVTOEDGE='\[\e[300D\]'
		CLR_PUNC='\[\e[01;34;44m\]'
		CLR_TEXT='\[\e[00;36;44m\]'
		CLR_NORM='\[\e[0m\]'
	;;
	*)
		MVTODASH=''
		MVTOEDGE=''
		CLR_PUNC=''
		CLR_TEXT=''
		CLR_NORM=''
	;;
esac

# Try to make it obvious that I'm root
if [ "$(whoami)" == "root" ]; then
	CLR_USER="\\[\\e[01;31;44m\\]"
	PATH="/sbin:/usr/sbin:/usr/local/sbin:$PATH"
	export PATH
else
	CLR_USER="$CLR_TEXT"
fi

# Now for the ugly
OLDCOLUMNS=0
LONGDASH_CACHE=''
LONGDASH='
	if [ "$OLDCOLUMNS" == "$COLUMNS" ]; then
		echo -n "$LONGDASH_CACHE"
	else
		DASH='';
		NODASH=$[ $COLUMNS / 4 + $COLUMNS / 4 + $COLUMNS / 4 ];
		while [ $NODASH != "0" ]; do
			DASH="$DASH~";
			NODASH=$[ $NODASH - 1 ];
		done;
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
		DASH='';
		if [ $COLUMNS -lt 80 ]; then
			DASH="~";
		else
			NODASH=$[ $COLUMNS / 4 ];
			while [ $NODASH != "0" ]; do
				DASH="$DASH~";
				NODASH=$[ $NODASH - 1 ];
			done;
		fi;
		echo -n "$DASH";
		SHRTDASH_CACHE="$DASH"

		unset DASH;
		unset NODASH;

		OLDCOLUMNS="$COLUMNS"
	fi;
'

# Time to actually set the prompt!
PS1="$CLR_PUNC\\[\$(eval $LONGDASH)\\]$MVTOEDGE[$CLR_USER\\u@\\h(\$SHLVL) $CLR_TEXT\$(__git_ps1 \"git:%s \")$CLR_PUNC|$CLR_TEXT \\@ \\d$CLR_PUNC]\$(eval $SHRTDASH)$CLR_NORM\\n\\w \\!\\\$ "
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
