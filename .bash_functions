# Functions
function mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Function to emulate the behavior of the `timeout` command
# Usage: timeout <duration_in_seconds> <command>
# Example: timeout 10 sleep 20

timeout() {
    duration=$1
    shift
    (sleep "$duration" && kill -9 $$) &
    "$@"
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
