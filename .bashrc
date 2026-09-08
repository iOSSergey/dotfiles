# shellcheck shell=bash
# Shared Bash settings

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
if [[ ${PROMPT_COMMAND:-} != *'history -a; history -n'* ]]; then
    PROMPT_COMMAND="history -a; history -n${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
fi

############################
# 3. Shell behavior
############################
shopt -s checkwinsize
shopt -s autocd
shopt -s globstar
set -o notify

############################
# 4. Locale
############################
if locale -a 2>/dev/null | grep -Eiq '^C\.?UTF-?8$'; then
    export LANG=C.UTF-8
fi

############################
# 5. PATH
############################
case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) PATH="$HOME/.local/bin:$PATH" ;;
esac

case ":$PATH:" in
    *":$HOME/bin:"*) ;;
    *) PATH="$HOME/bin:$PATH" ;;
esac
export PATH

############################
# 6. Less
############################
export LESS="-R -F -X"
export LESSHISTFILE="-"

############################
# 7. Dircolors
############################
if command -v dircolors >/dev/null 2>&1; then
    eval "$(dircolors -b)"
fi

############################
# 8. Bash completion
############################
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

############################
# 9. Prompt
############################
if command -v tput >/dev/null 2>&1 && [[ $(tput colors 2>/dev/null) -ge 8 ]]; then
    PS1='\[\e[1;33m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '
else
    PS1='\u@\h:\w\$ '
fi

# Add this to the end of your config file (usually ~/.bashrc)
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash)"
fi

# Activate fzf Key Bindings
if [ -r /usr/share/doc/fzf/examples/key-bindings.bash ]; then
    source /usr/share/doc/fzf/examples/key-bindings.bash
fi
