#!/bin/bash

source ~/.projects/lib.bash
cd_project ~/Documents/Personal/dotfiles

function save {
	echo "Copying dotfiles from ~/ to ${PWD}."
	local path
	for path in bin .vimrc .ctags .gitconfig .gitignore_global .git_template .inputrc .projects; do
		cp -va ~/"$path" ./
	done
	mkdir .ssh 
	cp -va ~/.ssh/config .ssh/config
	cp -va ~/.bash* ./
	# Backup pip installed packages.
	pip freeze > .pip-freeze
}

function restore {
	echo "Copying dotfiles from $PWD to ~/."
	local path
	for path in bin .vimrc .ctags .gitconfig .gitignore_global .git_template .inputrc .projects; do
		cp -va "$path" ~/
	done
	cp -va .ssh/config ~/.ssh/config
	cp -va .bash* ~/
	git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
}
