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
if (( BASH_VERSINFO[0] >= 4 )); then
    shopt -s autocd
    shopt -s globstar
fi
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
    elif [[ $OSTYPE == darwin* ]]; then
        for _dotfiles_completion_file in /opt/homebrew/etc/profile.d/bash_completion.sh /usr/local/etc/profile.d/bash_completion.sh; do
            if [ -r "$_dotfiles_completion_file" ]; then
                _DOTFILES_COMPLETION_FILE=$_dotfiles_completion_file
                break
            fi
        done
        unset _dotfiles_completion_file
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

# Keep Mac-specific preferences separate from the Linux defaults.
if [[ $OSTYPE == darwin* ]]; then
    export HISTSIZE=50000
    export HISTFILESIZE=100000
    HISTCONTROL=ignoredups:ignorespace
    unset HISTIGNORE

    bind '"\e[A": history-search-backward'
    bind '"\e[B": history-search-forward'

    export CLICOLOR=1
    export LSCOLORS=GxFxCxDxBxegedabagaced
    export KUBE_EDITOR=nano
    alias vi='vim'

    # Use the custom Mac display name without changing the system hostname.
    HOST_NAME=lobasto
    emojis=("👾" "🌐" "🎲" "🌍" "🐉" "🌵")
    EMOJI=${emojis[RANDOM % ${#emojis[@]}]}

    print_before_the_prompt() {
        local dir=${PWD/#"$HOME"/\~}
        local git_status=''
        if command -v vcprompt >/dev/null 2>&1; then
            git_status=$(vcprompt)
        fi

        printf '\n \033[0;31m%s: \033[1;35m%s \033[0;32m%s\n\033[0m' \
            "$HOST_NAME" "$dir" "$git_status"
    }

    if [[ ${PROMPT_COMMAND:-} != *print_before_the_prompt* ]]; then
        PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }print_before_the_prompt"
    fi
    PS1="$EMOJI >"

    # Show the welcome banner once per interactive shell.
    if [[ ${_DOTFILES_MAC_WELCOME_SHOWN:-} != 1 ]]; then
        _DOTFILES_MAC_WELCOME_SHOWN=1
        if command -v fortune >/dev/null 2>&1 && command -v cowsay >/dev/null 2>&1; then
            fortune | cowsay -f tux
        fi
    fi

    _dotfiles_load_kubectl_completion() {
        local binary metadata key cache_dir cache_file temporary
        binary=$(type -P kubectl) || return 0
        cache_dir=${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles

        # Include the resolved binary's identity so upgrades invalidate the cache.
        metadata=$(stat -L -f '%m:%c:%z:%i' "$binary" 2>/dev/null) || metadata=''
        if [[ -n $metadata ]]; then
            key=$(printf '%s\n%s\n' "$binary" "$metadata" | cksum)
            key=${key%% *}
            cache_file=$cache_dir/kubectl-$key.bash
            if [[ ! -s $cache_file ]]; then
                if (umask 077; mkdir -p "$cache_dir") &&
                    temporary=$(mktemp "$cache_dir/.kubectl.XXXXXX"); then
                    if "$binary" completion bash > "$temporary" && [[ -s $temporary ]]; then
                        mv -f "$temporary" "$cache_file"
                    else
                        rm -f "$temporary"
                    fi
                fi
            fi
        fi

        if [[ -n ${cache_file:-} && -s $cache_file ]]; then
            # shellcheck source=/dev/null
            source "$cache_file"
        else
            # Keep completion available when the cache cannot be written.
            # shellcheck source=/dev/null
            source <("$binary" completion bash)
        fi
        if declare -F __start_kubectl >/dev/null; then
            complete -o default -F __start_kubectl k
        fi
    }

    _dotfiles_load_completion() {
        [[ ${_DOTFILES_COMPLETION_LOADED:-} == 1 ]] && return 1
        # Restore the previous default, including fzf's fallback, before loading.
        complete -r -D
        if [[ -n ${_DOTFILES_COMPLETION_DEFAULT:-} ]]; then
            eval "$_DOTFILES_COMPLETION_DEFAULT"
        fi
        if [[ -n ${_DOTFILES_COMPLETION_FILE:-} ]]; then
            # shellcheck source=/dev/null
            source "$_DOTFILES_COMPLETION_FILE"
        fi
        _dotfiles_load_kubectl_completion
        _DOTFILES_COMPLETION_LOADED=1
        # Reattach fuzzy completion to the handlers loaded by Homebrew.
        if [[ -n ${_DOTFILES_FZF_INIT:-} ]]; then
            eval "$_DOTFILES_FZF_INIT"
            unset _DOTFILES_FZF_INIT
        fi
        # Ask Bash to retry completion using the newly registered handlers.
        return 124
    }

    if command -v fzf >/dev/null 2>&1; then
        # Older fzf releases do not support --bash.
        if _dotfiles_fzf_init=$(fzf --bash 2>/dev/null); then
            eval "$_dotfiles_fzf_init"
            if [[ ${_DOTFILES_COMPLETION_LOADED:-} != 1 ]]; then
                _DOTFILES_FZF_INIT=$_dotfiles_fzf_init
            fi
        fi
        unset _dotfiles_fzf_init
    fi

    if [[ ${_DOTFILES_COMPLETION_LOADED:-} != 1 ]] && ! shopt -oq posix; then
        if (( BASH_VERSINFO[0] >= 4 )); then
            # Preserve the original default across repeated profile reloads.
            if [[ $(complete -p -D 2>/dev/null) != *'_dotfiles_load_completion'* ]]; then
                _DOTFILES_COMPLETION_DEFAULT=$(complete -p -D 2>/dev/null) || :
            fi
            complete -D -o default -o bashdefault -F _dotfiles_load_completion
            # fzf registers its own handlers for commands such as git and ssh.
            if declare -F _fzf_handle_dynamic_completion >/dev/null; then
                _fzf_completion_loader=_dotfiles_load_completion
            fi
        else
            # Bash 3.2 has no default completion hook.
            if [[ -n ${_DOTFILES_COMPLETION_FILE:-} ]]; then
                # shellcheck source=/dev/null
                source "$_DOTFILES_COMPLETION_FILE"
            fi
            _dotfiles_load_kubectl_completion
            _DOTFILES_COMPLETION_LOADED=1
        fi
    fi
fi
