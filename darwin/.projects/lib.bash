#!/bin/bash
# Shared functions for bash project files.

COLOR_RESET="$(tput sgr0)"
COLOR_OK="${COLOR_RESET}$(tput setaf 2)"
COLOR_ERROR="${COLOR_RESET}$(tput setaf 1)$(tput setab 0)"

function print_ok {
  printf '%s%s%s\n' "${COLOR_OK}" "$*" "${COLOR_RESET}"
}

function print_error {
  printf '%s%s%s\n' "${COLOR_ERROR}" "$*" "${COLOR_RESET}" 1>&2
}

function cd_project {
  export PROJECT_PATH="$1"
  export VIM_TAGS="${PROJECT_PATH}/tags"

  cd "${PROJECT_PATH}" || exit 1

  # Only set CDPATH for interactive shells.
  if [[ $- == *i* ]]; then
    CDPATH=".:${PROJECT_PATH}"
  fi

  if [ -d "${PROJECT_PATH}/.git" ]; then
    git fetch
    git status
  fi
}

function tags {
  local kind="${1:-ctags}"
  case "${kind}" in
    ctags)
      ctags --recurse=yes -f tags 2> /dev/null
      ;;
    erltags)
      ~/.vim/bundle/vim-erlang-tags/bin/vim-erlang-tags.erl -p -o tags
      ctags --append --recurse=yes -f tags 2> /dev/null
      ;;
    gotags)
      gotags -R=true . > tags
      ctags --append --recurse=yes -f tags 2> /dev/null
      ;;
  esac
}

function activate_awsume {
  local aws_profile="${1}"
  if [ -n "${aws_profile}" ]; then
    eval "$(awsume "${aws_profile}" -s)"
  fi

  #Auto-Complete function for AWSume
  _awsume() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD - 1]}"
    opts=$(awsumepy --rolesusers)
    COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
    return 0
  }
  complete -F _awsume awsume

  alias awsume="source \"\$(which awsume)\""
}

function stop_docker_containers {
  local containers
  containers="$(docker ps -q)"
  if [ "${containers}" ]; then
    docker stop "${containers}"
  fi
}
