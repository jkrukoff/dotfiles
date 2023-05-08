#!/bin/bash
# .bashrc
# We export plenty of values used elsewhere, doesn't help for shellcheck to
# flag them.
# shellcheck disable=SC2034

# Pull in system defaults from known fedora and ubuntu directories.
for DEFAULT_FILE in /etc/bashrc /etc/bash.bashrc /etc/skel/.bashrc /usr/share/git-core/contrib/completion/git-prompt.sh; do
  if [ -f "${DEFAULT_FILE}" ]; then
    source "${DEFAULT_FILE}"
  fi
done
unset DEFAULT_FILE

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
alias pstree='pstree -g'
alias tree='tree -FA'
alias info='info --vi-keys'
alias have='which -s'
alias hl='source-highlight --failsafe -f esc256 -n -i'

# External functions.
source ~/bin/z.sh

# History variables.
HISTIGNORE='[	 ]*:&:bg:fg'
HISTCONTROL=ignoredups
HISTFILESIZE=0

# Prompt variables.

# Some defaults for minimal environments.
if [ -z "${COLUMNS}" ]; then
  export COLUMNS=80
fi
if [ -z "${TERM}" ]; then
  export TERM=vt100
fi

# Git prompt variables.
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWUPSTREAM=auto

# Common color codes.
PROMPT_COLOR_NORM="$(tput sgr0)"
PROMPT_COLOR_OK="${PROMPT_COLOR_NORM}$(tput setaf 6)"
PROMPT_COLOR_ERR="${PROMPT_COLOR_NORM}$(tput setaf 1)$(tput setab 5)"

PROMPT_COLOR_OK_PUNC="${PROMPT_COLOR_NORM}$(tput bold)$(tput setaf 4)$(tput setab 4)"
PROMPT_COLOR_OK_TEXT="${PROMPT_COLOR_NORM}$(tput setaf 5)$(tput setab 4)"
PROMPT_COLOR_OK_USER="${PROMPT_COLOR_NORM}$(tput setaf 5)$(tput setab 4)"
PROMPT_COLOR_OK_DIRSTATUS="${PROMPT_COLOR_NORM}$(tput setaf 3)$(tput setab 4)"
PROMPT_COLOR_OK_ROOT="${PROMPT_COLOR_NORM}$(tput setaf 1)$(tput setab 4)"

PROMPT_COLOR_ERR_PUNC="${PROMPT_COLOR_NORM}$(tput bold)$(tput setaf 5)$(tput setab 5)"
PROMPT_COLOR_ERR_TEXT="${PROMPT_COLOR_NORM}$(tput setaf 6)$(tput setab 5)"
PROMPT_COLOR_ERR_USER="${PROMPT_COLOR_NORM}$(tput setaf 6)$(tput setab 5)"
PROMPT_COLOR_ERR_DIRSTATUS="${PROMPT_COLOR_NORM}$(tput setaf 3)$(tput setab 5)"
PROMPT_COLOR_ERR_ROOT="${PROMPT_COLOR_NORM}$(tput setaf 1)$(tput setab 5)"

function prompt_colors {
  local exit_code="${1:-$?}"

  if [ "${exit_code}" -eq 0 ]; then
    PROMPT_COLOR_PUNC="${PROMPT_COLOR_OK_PUNC}"
    PROMPT_COLOR_TEXT="${PROMPT_COLOR_OK_TEXT}"
    PROMPT_COLOR_USER="${PROMPT_COLOR_OK_USER}"
    PROMPT_COLOR_DIRSTATUS="${PROMPT_COLOR_OK_DIRSTATUS}"
    PROMPT_COLOR_ROOT="${PROMPT_COLOR_OK_ROOT}"
  else
    PROMPT_COLOR_PUNC="${PROMPT_COLOR_ERR_PUNC}"
    PROMPT_COLOR_TEXT="${PROMPT_COLOR_ERR_TEXT}"
    PROMPT_COLOR_USER="${PROMPT_COLOR_ERR_USER}"
    PROMPT_COLOR_DIRSTATUS="${PROMPT_COLOR_ERR_DIRSTATUS}"
    PROMPT_COLOR_ROOT="${PROMPT_COLOR_ERR_ROOT}"
  fi
}

# Ensure we've got some default color variables set, even before the prompt is
# generated for the first time.
prompt_colors 0

function dashed_line {
  local dash
  local justify="$2"
  dash="$(eval "printf ~%.0s {1..$1}")"

  if [ "${justify}" = right ]; then
    # Right justify.
    local move_to_edge move_to_dash
    move_to_edge="$(tput cr)"
    move_to_dash="${move_to_edge}$(tput cuf $(($(tput cols) - ${#dash} - 1)))"
    printf "%s" "${move_to_edge}${move_to_dash}${dash}"
  else
    # Left justify
    printf "%s" "${dash}"
  fi
}

function prompt {
  local OPTIND ARG enable_git
  while getopts "gh" ARG "$@"; do
    case ${ARG} in
      g)
        enable_git="true"
        ;;
      h)
        echo "prompt: -g, -h" 1>&2
        return
        ;;
      ?)
        return 1
        ;;
    esac
  done

  # Set status line for terminals that support it.
  local status_line
  if tput hs; then
    status_line="\\[$(tput tsl)\\][\\u@\\h(\${SHLVL})]: \${PWD}\\[$(tput fsl)\\]"
  fi

  # Try to make it obvious that I'm root.
  local color_user
  if [ "$(id -u)" -eq 0 ]; then
    color_user="\\[\${PROMPT_COLOR_ROOT}\\]"
  else
    color_user="\\[\${PROMPT_COLOR_USER}\\]"
  fi

  local git_prompt
  if [ "${enable_git}" ]; then
    git_prompt="\$(__git_ps1 \"git:%s \")"
  fi

  local long_dash info_block
  long_dash="\\[\${PROMPT_COLOR_PUNC}\$(dashed_line \"\${COLUMNS}\" left)$(tput cr)\\]"
  info_block="[${color_user}\\u@\\h(\${SHLVL}) \\[\${PROMPT_COLOR_DIRSTATUS}\\]${git_prompt}\\[\${PROMPT_COLOR_PUNC}\\]|\\[\${PROMPT_COLOR_TEXT}\\] \\@ \\d\\[\${PROMPT_COLOR_PUNC}\\]]"

  # Time to actually set the prompt!
  PROMPT_COMMAND=prompt_colors
  PS1="${status_line}${long_dash}${info_block}\\[\${PROMPT_COLOR_NORM}\\]\\n\\w \\!\\\$ "
  PS2='\w \!>'
  PS4='+ \!>'
}

prompt -g

# Project management and switching.

# List all available projects.
function projects {
  find ~/.projects/*.bash -type f -name lib.bash -prune -o -exec basename -s .bash \{\} \; | sort
}

# Switch to a project.
function project {
  local project="$*"
  project=${project// /_}
  project=${project//-/_}

  prompt_colors 0

  # If no arguments, display current project.
  if [ -z "${project}" ]; then
    if [ -z "${ACTIVE_PROJECT}" ]; then
      return 1
    else
      printf '%s\n' "${ACTIVE_PROJECT}"
      return
    fi
  fi

  function dashed_line_colored {
    echo -n "${PROMPT_COLOR_PUNC}"
    dashed_line "${COLUMNS}" left
    echo -n "${PROMPT_COLOR_NORM}"
  }

  local project_file=~/".projects/${project}.bash"

  # If no match, look for something close.
  if [ ! -r "${project_file}" ]; then
    local closest
    closest="$(
      basename -a -s '.bash' ~/.projects/*.bash |
        grep -F "${project}" |
        awk '(NR==1 || length<shortest){shortest=length; line=$0} END {print line}'
    )"
    project_file=~/".projects/${closest}.bash"
  fi

  if [ -r "${project_file}" ]; then
    project="$(basename -a -s '.bash' "${project_file}")"
    echo -ne '\n\n'
    dashed_line_colored
    echo "${PROMPT_COLOR_OK}Switching to project: ${project}"
    dashed_line_colored
    echo -ne '\n\n'
    ACTIVE_PROJECT="${project}" bash --init-file <(echo "source ~/.bashrc && source \"${project_file}\"")
  else
    echo "${PROMPT_COLOR_ERR}No project file for: ${project}"
  fi
}

# Track user login/out activity.
TRACK_WHO=""
function track_who {
  local who
  who="$(who | cut -d ' ' -f 1 | sort -u)"
  if [ "${who}" != "${TRACK_WHO}" ]; then
    comm <(echo "${TRACK_WHO}") <(echo "${who}")
  fi
  TRACK_WHO="${who}"
}

# Enable SSH agent if not already running.

if [ -z "${SSH_AGENT_PID}" ]; then
  eval "$(ssh-agent -s)" > /dev/null
fi
