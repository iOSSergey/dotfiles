# ~/.bashrc — Debian 12 canonical
# Loaded for interactive non-login shells

############################
# 1. Exit if not interactive
############################
[[ $- != *i* ]] && return

############################
# 2. History configuration
############################
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoredups:erasedups
HISTIGNORE="ls:ll:pwd:exit:clear"
shopt -s histappend
PROMPT_COMMAND='history -a; history -c; history -r'

############################
# 3. Shell behavior
############################
shopt -s checkwinsize
shopt -s autocd
shopt -s globstar
set -o notify

############################
# 4. Locale (safe default)
############################
export LANG=C.UTF-8
export LC_ALL=C.UTF-8

############################
# 5. PATH
############################
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

############################
# 6. Less
############################
export LESS="-R -F -X"
export LESSHISTFILE="-"

############################
# 7. Prompt
############################
if command -v tput &>/dev/null && [[ $(tput colors) -ge 8 ]]; then
    PS1='\[\e[1;33m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '
else
    PS1='\u@\h:\w\$ '
fi

############################
# 8. Aliases
############################
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

############################
# 9. Functions
############################
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

############################
# 10. Bash completion
############################
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

############################
# 11. Modular extensions
############################
# Load all *.sh from ~/.bashrc.d/
if [ -d "$HOME/.bashrc.d" ]; then
    for file in "$HOME/.bashrc.d"/*.sh; do
        [ -r "$file" ] && . "$file"
    done
fi

############################
# 12. Dircolors
############################
if command -v dircolors &>/dev/null; then
    eval "$(dircolors -b)"
fi

# Add this to the end of your config file (usually ~/.bashrc)
#eval "$(zoxide init bash)"

# Activate fzf Key Bindings
#source /usr/share/doc/fzf/examples/key-bindings.bash

