#!/bin/bash
# Shared functions for bash project files.

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

function start_docker {
	exit 1
}

function stop_docker_containers {
	local containers="$(docker ps -q)"
	if [ "$containers" ]; then
		docker stop $containers
	fi
}
