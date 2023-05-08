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
  case "$#" in
    0)
      if [ -n "${PROJECT_PATH}" ]; then
        print_error "$0: Not in a project."
      fi
      cd "${PROJECT_PATH}" || exit 1
      exit 0
      ;;
    1|2)
      ;;
    *)
      print_error "$0: Invalid arguments."
      exit 1
      ;;
  esac

  local project_path="$1" project_repo="$2"

  export VIM_TAGS="${PROJECT_PATH}/tags"
  local projects_path="${PROJECTS_PATH:=~/Documents}"

  # If given path is absolute, use as is. Otherwise, it's relative to
  # $PROJECTS_PATH.
  if [[ "${project_path}" =~ ^/|^~ ]]; then
    PROJECT_PATH=${project_path}
  else
    PROJECT_PATH="${projects_path}/${project_path}"
  fi
  export PROJECT_PATH

  if ! cd "${PROJECT_PATH}" 2>/dev/null; then
    # If project directory doesn't exist and we know where to get it from, go
    # ahead and check it out.
    if [ -n "${project_repo}" ]; then
      git clone "${project_repo}" "${PROJECT_PATH}" || exit 1
      cd "${PROJECT_PATH}"
    else
      exit 1
    fi
  fi

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

function start_docker {
  if ! docker version > /dev/null; then
    sudo systemctl start docker
  fi
}

function stop_docker_containers {
  local containers
  containers="$(docker ps -q)"
  if [ "${containers}" ]; then
    docker stop "${containers}"
  fi
}
