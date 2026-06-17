#!/usr/bin/env bash

set -e

backup_if_exists() {
  local path="$1"
  if [ -e "$path" ] || [ -L "$path" ]; then
    mv -f "$path" "${path}.bak"
  fi
}

backup_if_exists "$HOME/.bashrc"
backup_if_exists "$HOME/.bash_aliases"
backup_if_exists "$HOME/.bash_functions"

ln -sf "$PWD/.bashrc" ~/.bashrc
ln -sf "$PWD/.bash_aliases" ~/.bash_aliases
ln -sf "$PWD/.bash_functions" ~/.bash_functions

source ~/.bashrc
