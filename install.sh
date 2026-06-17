#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

confirm_overwrite() {
  local dest="$1"
  if [ ! -t 0 ]; then
    return 1
  fi

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

link_file() {
  local src dest
  src="$1"
  dest="$2"

  if [ ! -e "$src" ]; then
    printf 'Skipping missing source file: %s\n' "$src" >&2
    return
  fi

  if [ -L "$dest" ] || [ -e "$dest" ]; then
    if [ "$(realpath "$src")" = "$(realpath "$dest")" ]; then
      printf 'Already installed, skipping: %s\n' "$dest"
      return
    fi

    if confirm_overwrite "$dest"; then
      rm -f "$dest"
    else
      printf 'Skipped: %s\n' "$dest"
      return
    fi
  fi

  ln -sf "$src" "$dest"
  printf 'Linked %s -> %s\n' "$dest" "$src"
}

link_file "$SCRIPT_DIR/.bashrc" "$HOME/.bashrc"
link_file "$SCRIPT_DIR/.bash_aliases" "$HOME/.bash_aliases"
link_file "$SCRIPT_DIR/.bash_functions" "$HOME/.bash_functions"

if [ -f "$HOME/.bashrc" ]; then
  # shellcheck disable=SC1090
  source "$HOME/.bashrc"
fi
