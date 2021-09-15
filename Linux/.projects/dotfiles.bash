#!/bin/bash

source ~/.projects/lib.bash
cd_project ~/Documents/dotfiles/"$(uname)"
tags

function save {
  echo "Copying dotfiles from ~/ to ${PWD}."
  local path
  for path in bin .vimrc .ctags .dcrc .gitconfig .gitignore_global .git_template .inputrc .tool-versions .projects; do
    cp -va ~/"${path}" ./
  done
  mkdir .ssh 
  cp -va ~/.ssh/config .ssh/config
  cp -va ~/.bash* ./
  cp -va ~/.vim-templates ./

  # Backup pip installed packages.
  pip3 freeze > .pip-installed

  # Sanitize some secrets.
  sed -i '/^export .*TOKEN/d' .bash_profile

  # Distribution specific packaging.
  case "$(lsb_release --id -s)" in
    Fedora)
      # Backup installed packages.
      dnf list --installed > .rpm-installed
      # Backup sources.
      cp -va /etc/yum.repos.d ./
      ;;
    Ubuntu)
      # Backup installed packages.
      dpkg --get-selections > .deb-installed
      # Backup sources.
      cp -va /etc/apt/sources.list.d ./
      ;;
  esac
}

function restore {
  echo "Copying dotfiles from $PWD to ~/."
  local path
  for path in bin .vimrc .ctags .dcrc .gitconfig .gitignore_global .git_template .inputrc .projects; do
    cp -va "$path" ~/
  done
  cp -va .ssh/config ~/.ssh/config
  cp -va .bash* ~/
  mkdir ~/.vim-templates
  cp -va .vim-templates/* ~/.vim-templates/

  # Remember some gnome settings.
  gsettings set org.gnome.desktop.wm.preferences focus-mode sloppy

  # Install and initialize vim-plug, a vim plugin manager.
  curl -#L --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -o ~/.vim/autoload/plug.vim
  vim +PlugInstall +qall

  # Install Z, a directory jump utility.
  curl -#L https://raw.githubusercontent.com/rupa/z/master/z.sh -o ~/bin/z.sh

  # Install asdf, a generic version management tool.
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.7.4

  # Install terraform-docs, a terraform documentation generation tool.
  curl -#L https://github.com/segmentio/terraform-docs/releases/download/v0.6.0/terraform-docs_linux_amd64 -o ~/bin/terraform-docs
}
