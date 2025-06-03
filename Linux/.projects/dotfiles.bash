#!/bin/bash

source ~/.projects/lib.bash
cd_project ~/local/dotfiles/"$(uname)"
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
  local option dotfiles_only

  # With -o set, we'll only copy files and not do the rest of the setup.
  # Helpful when working on the files in the dotfiles repo and wanting to keep
  # ${HOME} in sync.
  while getopts "o" option; do
    case "${option}" in
      o)
        dotfiles_only="true"
        ;;
      ?)
        return 1
        ;;
    esac
  done
  shift $((OPTIND - 1))

  echo "Copying dotfiles from $PWD to ~/."
  local path
  for path in bin .vimrc .ctags .dcrc .gitconfig .gitignore_global .git_template .inputrc .tool-versions .projects; do
    cp -va "${path}" ~/
  done

  cp -va .bash* ~/

  mkdir ~/.ssh
  cp -va .ssh/config ~/.ssh/config
  chmod 600 ~/.ssh/config

  mkdir ~/.vim-templates
  cp -va .vim-templates/* ~/.vim-templates/

  if [ -n "${dotfiles_only}" ]; then
    return 0
  fi

  # Remember some gnome settings.
  gsettings set org.gnome.desktop.wm.preferences focus-mode sloppy

  # Install and initialize vim-plug, a vim plugin manager.
  curl -#L --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -o ~/.vim/autoload/plug.vim
  vim +PlugInstall +qall

  # Install Z, a directory jump utility.
  curl -#L https://raw.githubusercontent.com/rupa/z/master/z.sh -o ~/bin/z.sh

  # Install asdf, a generic version management tool.
  local asdf_tempdir asdf_url
  asdf_tempdir="$(mktemp --tmpdir --directory dotfiles-restore-asdf.XXXXXX)"
  asdf_url="$(curl -sL https://api.github.com/repos/asdf-vm/asdf/releases/latest | sed -nE '/"browser_download_url": *"[^"]*-linux-amd64.tar.gz"/s/ *"browser_download_url": *"([^"]*)"/\1/p')"
  curl -#L "${asdf_url}" -o "${asdf_tempdir}/asdf.tar.gz"
  tar -zvf "${asdf_tempdir}/asdf.tar.gz" -C ~/bin -x asdf

  local plugin
  while IFS= read -r line; do
    plugin=$(echo "$line" | cut -d ' ' -f 1)
    ~/bin/asdf plugin add "${plugin}"
  done < ~/.tool-versions
}
