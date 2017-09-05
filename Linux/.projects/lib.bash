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
	local virtualenv_dir="${1:-.virtualenv}"
	if [ -d "$virtualenv_dir" ]; then
		source "$virtualenv_dir"/bin/activate
		echo "Python virtualenv found and activated: $(python --version)"
	fi
}

function activate_nvm {
	local nvm_version="${1:-v6.11.0}"
	local nvm_dir="${2:-${HOME}/.nvm}"
	export NVM_DIR="${nvm_dir}"
	source "${nvm_dir}/nvm.sh"
	nvm use "${nvm_version}"
	export PATH="$(npm bin):${PATH}"
}

function activate_rbenv {
	local rbenv_version="${1:-2.4.0}"
	eval "$(rbenv init -)"
	rbenv local "${rbenv_version}"
	rbenv version
}

function activate_gcloud {
	GCLOUD_PATH="$(gcloud info --format=flattened | grep '^installation.sdk_root: ' | tr -s ' ' | cut -f 2 -d ' ')"
	export PATH="${GCLOUD_PATH}/bin:$PATH"
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
