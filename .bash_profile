# Load the shared configuration for interactive login shells on macOS.
[[ $- != *i* ]] && return

DOTFILES="$HOME/.dotfiles"
[ -r "$DOTFILES/.bashrc" ] && source "$DOTFILES/.bashrc"
[ -r "$DOTFILES/.bash_aliases" ] && source "$DOTFILES/.bash_aliases"
[ -r "$DOTFILES/.bash_functions" ] && source "$DOTFILES/.bash_functions"
