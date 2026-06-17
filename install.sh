#!/usr/bin/env bash

set -euo pipefail

REPO_URL="https://github.com/iOSSergey/dotfiles.git"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
FILES=(.bashrc .bash_aliases .bash_functions)

error() {
  printf '%s\n' "$*" >&2
  exit 1
}

info() {
  printf '%s\n' "$*"
}

ask_overwrite() {
  local dest_list="$1"
  local response
  local input=/dev/tty

  if [ ! -r "$input" ]; then
    error "Cannot prompt for overwrite because /dev/tty is unavailable."
  fi

  while true; do
    read -r -p "Found existing files: $dest_list. Overwrite them? [y/N] " response <"$input"
    case "$response" in
      [yY]|[yY][eE][sS]) return 0 ;; 
      [nN]|'' ) return 1 ;; 
      *) printf 'Please answer yes or no.\n' ;; 
    esac
  done
}

ensure_git() {
  if command -v git >/dev/null 2>&1; then
    return
  fi

  if ! command -v apt-get >/dev/null 2>&1; then
    error "Git is required to install dotfiles. Install git manually and rerun."
  fi

  info "Git not found. Installing git via apt."
  if [ "$EUID" -ne 0 ]; then
    sudo apt-get update
    sudo apt-get install -y git
  else
    apt-get update
    apt-get install -y git
  fi

  if ! command -v git >/dev/null 2>&1; then
    error "Git installation failed. Please install git manually and rerun."
  fi
}

clone_or_update_repo() {
  if [ -d "$DOTFILES_DIR/.git" ]; then
    info "Updating existing dotfiles repository in $DOTFILES_DIR"
    git -C "$DOTFILES_DIR" pull --quiet --ff-only origin main 2>/dev/null || true
    git -C "$DOTFILES_DIR" fetch --quiet --all --prune
  else
    info "Cloning dotfiles repository into $DOTFILES_DIR"
    git clone --quiet --depth 1 "$REPO_URL" "$DOTFILES_DIR"
  fi
}

link_dotfile() {
  local file="$1"
  local src="$DOTFILES_DIR/$file"
  local dest="$HOME/$file"

  if [ ! -e "$src" ]; then
    info "Skipping missing dotfile: $file"
    return
  fi

  cp -f -- "$src" "$dest"
  info "Installed $file"
}

main() {
  ensure_git
  clone_or_update_repo

  local existing_files=()
  for file in "${FILES[@]}"; do
    local dest="$HOME/$file"
    if [ -e "$dest" ] || [ -L "$dest" ]; then
      existing_files+=("$file")
    fi
  done

  if [ ${#existing_files[@]} -gt 0 ]; then
    local list
    list=$(printf '%s, ' "${existing_files[@]}")
    list=${list%, }
    if ! ask_overwrite "$list"; then
      info "Thank you. Exiting."
      exit 0
    fi
  fi

  for file in "${FILES[@]}"; do
    link_dotfile "$file"
  done

  if [ -f "$HOME/.bashrc" ]; then
    # shellcheck disable=SC1090
    source "$HOME/.bashrc"
  fi
}

main
