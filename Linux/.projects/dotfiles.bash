#!/bin/bash

source ~/.projects/lib.bash
cd_project ~/Documents/Personal/dotfiles/"$(uname)"
tags

function save {
	echo "Copying dotfiles from ~/ to ${PWD}."
	local path
	for path in bin .vimrc .ctags .gitconfig .gitignore_global .git_template .inputrc .projects; do
		cp -va ~/"$path" ./
	done
	mkdir .ssh 
	cp -va ~/.ssh/config .ssh/config
	cp -va ~/.bash* ./
	cp -va ~/.vim-templates ./

	# Sanitize some secrets.
	sed -i '/^export .*TOKEN/d' .bash_profile

	# Backup installed packages.
	dpkg --get-selections > .deb-installed

	# Backup sources.
	cp -va /etc/apt/sources.list.d ./

	# Backup pip installed packages.
	pip freeze > .pip-installed
}

function restore {
	echo "Copying dotfiles from $PWD to ~/."
	local path
	for path in bin .vimrc .ctags .gitconfig .gitignore_global .git_template .inputrc .projects; do
		cp -va "$path" ~/
	done
	cp -va .ssh/config ~/.ssh/config
	cp -va .bash* ~/
	cp -va .vim-templates/* ~/

	# Remember some gnome settings.
	gsettings set org.gnome.desktop.wm.preferences focus-mode sloppy

	# Install and initialize vundle.
	git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	vim +PluginInstall +qall

	# Install Z directory jump utility.
	curl -#L https://raw.githubusercontent.com/rupa/z/master/z.sh -o ~/bin/z.sh

	# Install kerl, an erlang environment build tool.
	curl -#L https://raw.githubusercontent.com/yrashk/kerl/master/kerl -o ~/bin/kerl
}
