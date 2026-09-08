#!/usr/bin/env bash

set -euo pipefail

REPO_URL="https://github.com/iOSSergey/dotfiles.git"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
BASH_FILES=(.bashrc .bash_aliases .bash_functions)

if [ -f /System/Library/CoreServices/SystemVersion.plist ]; then
  BASH_CONFIG_FILE="$HOME/.bash_profile"
else
  BASH_CONFIG_FILE="$HOME/.bashrc"
fi

BASH_CONFIG_LINES=(
  "DOTFILES=\"\$HOME/.dotfiles\""
  "[ -r \"\$DOTFILES/.bashrc\" ] && source \"\$DOTFILES/.bashrc\""
  "[ -r \"\$DOTFILES/.bash_aliases\" ] && source \"\$DOTFILES/.bash_aliases\""
  "[ -r \"\$DOTFILES/.bash_functions\" ] && source \"\$DOTFILES/.bash_functions\""
)

error() {
  printf '%s\n' "$*" >&2
  exit 1
}

ensure_git() {
  if [ -f /System/Library/CoreServices/SystemVersion.plist ]; then
    if ! command -v brew >/dev/null 2>&1; then
      error "Homebrew is required to install Git on macOS. Install Homebrew and rerun."
    fi

    if ! brew list --versions git >/dev/null 2>&1; then
      brew install git
    fi
  elif command -v git >/dev/null 2>&1; then
    return
  elif ! command -v apt-get >/dev/null 2>&1; then
    error "Git is required to install dotfiles. Install git manually and rerun."
  elif [ "$EUID" -ne 0 ]; then
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
    git -C "$DOTFILES_DIR" pull --quiet --ff-only origin main 2>/dev/null || true
    git -C "$DOTFILES_DIR" fetch --quiet --all --prune
  else
    git clone --quiet --depth 1 "$REPO_URL" "$DOTFILES_DIR"
  fi
}

ensure_bash_files() {
  local file="$1"

  if [ ! -e "$DOTFILES_DIR/$file" ]; then
    error "Missing $DOTFILES_DIR/$file."
  fi
}

line_exists() {
  local line="$1"
  local file="$2"

  grep -Fqx -- "$line" "$file"
}

ensure_bash_config() {
  local line
  local missing_lines=()
  local needs_update=0

  if [ -L "$BASH_CONFIG_FILE" ]; then
    error "$BASH_CONFIG_FILE is a symlink. Replace it with a regular file and rerun."
  fi

  if [ ! -e "$BASH_CONFIG_FILE" ]; then
    : >"$BASH_CONFIG_FILE"
  fi

  for line in "${BASH_CONFIG_LINES[@]}"; do
    if ! line_exists "$line" "$BASH_CONFIG_FILE"; then
      missing_lines+=("$line")
      needs_update=1
    fi
  done

  if [ "$needs_update" -eq 0 ]; then
    return
  fi

  {
    printf '\n'
    for line in "${missing_lines[@]}"; do
      printf '%s\n' "$line"
    done
  } >>"$BASH_CONFIG_FILE"
}

main() {
  ensure_git
  clone_or_update_repo

  for file in "${BASH_FILES[@]}"; do
    ensure_bash_files "$file"
  done

  ensure_bash_config

  printf 'Done. Installation completed. Please run "source %s" to apply the changes.\n' "$BASH_CONFIG_FILE"
}

main
