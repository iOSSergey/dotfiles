# shellcheck shell=bash
# Functions
function mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Delegate to an installed timeout implementation; never signal the shell.
timeout() {
    if type -P timeout >/dev/null 2>&1; then
        command timeout "$@"
    elif type -P gtimeout >/dev/null 2>&1; then
        command gtimeout "$@"
    else
        printf 'timeout requires GNU coreutils (on macOS: brew install coreutils).\n' >&2
        return 127
    fi
}

# Remove legacy aliases before defining functions, including during reloads.
unalias h p x pma 2>/dev/null || :

# Show the last N history entries without defining a shared helper function.
h() {
    local count=${1:-20}
    [[ $count =~ ^[1-9][0-9]*$ ]] || {
        printf 'Usage: h [positive_count]\n' >&2
        return 2
    }
    history | tail -n "$count" | awk '
        { printf "\033[1;32m%5s\033[0m  %s\n", $1, substr($0, index($0, $2)) }
    '
}

# Show the most frequent remote IPv4/IPv6 endpoints for a port.
p() {
    [[ $# -eq 1 && $1 =~ ^[0-9]+$ ]] || {
        printf 'Usage: p <port>\n' >&2
        return 2
    }
    netstat -tn | awk -v port="$1" '
        $4 ~ (":" port "$") || $5 ~ (":" port "$") { print $5 }
    ' | sed -E 's/^\[?([^]]+)\]?(:[0-9]+)$/\1/' |
        sort | uniq -c | sort -nr | head -n 20
}

# Pass the search pattern as an argument instead of interpolating shell code.
x() {
    [[ $# -eq 1 ]] || {
        printf 'Usage: x <pattern>\n' >&2
        return 2
    }
    docker exec 3x-ui sh -c 'grep -- "$1" /app/access.log | tail -n 80' sh "$1"
}

# Start phpMyAdmin detached and stop this exact container after one hour.
pma() {
    local container
    container=$(docker run --rm --name pma -d -e PMA_ARBITRARY=1 -p 8080:80 phpmyadmin) || return
    nohup sh -c 'sleep 3600 && docker stop "$1"' sh "$container" </dev/null >/dev/null 2>&1 &
    printf '%s\n' "$container"
}

# Function to display a range of history commands with highlighted target line
# Usage: hl <line_number> [range]
# Example: hl 9603 10

hl() {
  # Check if line number is provided and highlight the target line
  [[ $# -eq 0 ]] && { echo "Usage: hl <line_number> [range]" >&2; return 1; }

  # Extract line and range (default to 10)
  local LINE=$1 RANGE=${2:-10}

  # Output history with specified range
  history | awk -v start=$((LINE - RANGE)) -v end=$((LINE + RANGE)) -v target=$LINE '
    NR >= start && NR <= end {
      if (NR == target)
        print "\033[1;31m" $0 "\033[0m"; # Highlight target line in red
      else
        print $0;
    }'
}

# Function to show interfaces or query ipinfo.io
# Usage: i [ip_or_hostname]
# Example: i 1.1.1.1

i() {
  if [ $# -eq 0 ]; then
    ip -c a
  elif [ "$1" = "me" ]; then
    curl -s icanhazip.com
  elif [[ "$1" =~ ^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]; then
    local target="$*"
    curl -s "https://ipinfo.io/${target}"
  else
    ip
  fi
}

# Function to show top-N commands by first token from interactive history
# Usage: topcmds [N]
# Example: topcmds 30
topcmds() {
	echo
  local N="${1:-20}"
  history | awk -v N="$N" '
    {
      line=$0
      # Strip leading history number
      sub(/^[[:space:]]*[0-9]+[[:space:]]+/,"", line)
      if (line=="") next
      # Extract first token as command name
      cmd=line
      sub(/[[:space:]].*/,"", cmd)
      count[cmd]++
    }
    END {
      for (c in count) printf "%7d  %s\n", count[c], c
    }' | sort -nr | head -n "$N"
}

# Automatically list directory contents after changing directories
function cd() {
    builtin cd "$@" && ls -la
}
