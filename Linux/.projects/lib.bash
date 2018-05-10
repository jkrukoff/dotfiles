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

	if [ -d "$PROJECT_PATH/.git" ]; then
		git fetch
		git status
	fi
}

function tags {
	local kind="${1:ctags}"
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

function activate_awsume {
	#Auto-Complete function for AWSume
	_awsume() {
		local cur prev opts
		COMPREPLY=()
		cur="${COMP_WORDS[COMP_CWORD]}"
		prev="${COMP_WORDS[COMP_CWORD-1]}"
		opts=$(awsumepy --rolesusers)
		COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
		return 0
	}
	complete -F _awsume awsume
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
