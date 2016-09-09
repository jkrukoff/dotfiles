#!/bin/bash
# Shared functions for bash project files.

COLOR_RESET="$(tput sgr0)"
COLOR_OK="${COLOR_RESET}$(tput setaf 2)"
COLOR_ERROR="${COLOR_RESET}$(tput setaf 1)$(tput setab 0)"

function print_ok {
	printf "%s%s%s\n" "${COLOR_OK}" "$*" "${COLOR_RESET}"
}

function print_error {
	printf "%s%s%s\n" "${COLOR_ERROR}" "$*" "${COLOR_RESET}" 1>&2
}

function cd_project {
	export PROJECT_PATH="$1"
	export VIM_TAGS="$PROJECT_PATH/tags"

	cd "$PROJECT_PATH"

	# Only set CDPATH for interactive shells.
	if [[ $- == *i* ]]; then
		CDPATH=".:$PROJECT_PATH"
	fi

	if [ -n "$(find . -maxdepth 2 -name '*.go' -print -quit)" ]; then
		gotags -R=true . > tags
	else
		ctags --recurse=yes -f - > tags 2> /dev/null
	fi

	if [ -d "$PROJECT_PATH/.git" ]; then
		git fetch
		git status
	fi
}

function activate_virtualenv {
	if [ -d .virtualenv ]; then
		source .virtualenv/bin/activate
		echo "Python virtualenv found and activated: $(python --version)"
	fi
}

function start_docker {
	if ! docker version > /dev/null; then
		sudo systemctl start docker
	fi
}

function stop_docker_containers {
	local containers="$(docker ps -q)"
	if [ "$containers" ]; then
		docker stop $containers
	fi
}
