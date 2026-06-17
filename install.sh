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
  local dest="$1"
  local response

  while true; do
    read -rp "Destination exists: $dest. Overwrite? [y/N] " response
    case "$response" in
      [yY]|[yY][eE][sS]) return 0 ;; 
      [nN]|'' ) return 1 ;; 
      *) printf 'Please answer yes or no.\n' ;; 
    esac
  done
}

backup_file() {
  local path="$1"
  local timestamp
  timestamp=$(date +%Y%m%d%H%M%S)

  if [ -e "$path" ] || [ -L "$path" ]; then
    mv -f "$path" "${path}.bak.$timestamp"
    info "Backed up $path -> ${path}.bak.$timestamp"
  fi
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
    git -C "$DOTFILES_DIR" pull --ff-only origin main 2>/dev/null || true
    git -C "$DOTFILES_DIR" fetch --all --prune
  else
    info "Cloning dotfiles repository into $DOTFILES_DIR"
    git clone --depth 1 "$REPO_URL" "$DOTFILES_DIR"
  fi
}

link_dotfile() {
  local file="$1"
  local src="$DOTFILES_DIR/$file"
  local dest="$HOME/$file"

  if [ ! -e "$src" ]; then
    info "Skipping missing file: $src"
    return
  fi

  if [ -L "$dest" ] && [ "$(readlink -f "$dest")" = "$src" ]; then
    info "Already linked: $dest"
    return
  fi

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    if ask_overwrite "$dest"; then
      backup_file "$dest"
    else
      info "Skipped: $dest"
      return
    fi
  fi

  ln -sf "$src" "$dest"
  info "Linked $dest -> $src"
}

main() {
  ensure_git
  clone_or_update_repo
  for file in "${FILES[@]}"; do
    link_dotfile "$file"
  done

  if [ -f "$HOME/.bashrc" ]; then
    # shellcheck disable=SC1090
    source "$HOME/.bashrc"
  fi
}

main
