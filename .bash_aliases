# Custom Aliases
alias python=python3 # Ensure Python 3 is used by default
alias ap='ansible-playbook'

# Navigation Aliases
alias dev='cd ~/dev'
alias w3='cd ~/dev'
alias w3s='cd ~/dev/base-mdb/v4/client_management_system; source ~/dev/base-mdb/v4/.venv/bin/activate'
alias ba='cd ~/backup'
alias bael='cd ~/backup/eltour'
alias bagr='cd ~/backup/grenada'
alias balo='cd ~/backup/lobasto'
alias bs='cd ~/dev/scripts/backup_scripts/active_scripts'
alias mpw='cd ~/dev/my-personal-website'
alias k8s='cd ~/dev/kubernetes'
alias eks='cd ~/dev/kubernetes/eks-manifests'
alias dia='cd ~/dev/docker/docker-in-action-app'
alias map='cd ~/dev/my-ansible-project'
alias tp='cd ~/dev/terraform'

# SSH Aliases
alias el='ssh eldorado' # SSH to specific server
alias am='ssh ams'
alias lo='ssh lobasto' # Keep SSH connection alive
alias owrt='ssh local-openwrt'
alias ec2='ssh us-aws-ec2'
alias gr='ssh grenada'
alias ca='ssh carmelia'

# File Management Aliases

# System Management Aliases
alias b='vi ~/.bashrc && source ~/.bashrc'
alias a='vi ~/.bash_{aliases,functions} && source ~/.bashrc'
alias up='sudo apt update && sudo apt upgrade -y'
alias ut='uptime'
alias ap2log='sudo tail -f /var/log/apache2/error.log'
alias ap2restart='sudo service apache2 restart'

# DevOps one-letter aliases (QWERTY order). Add to ~/.bashrc or ~/.bash_aliases
# NOTE: Some tools (rg, yq, z, podman, helm, terraform, aws) may require installation.

# Row 1: QWERTYUIOP
alias q='jq'                 # JSON processor
alias w="watch -n 2 'uptime; echo; free -m; echo; ss -s | head -10'"       # Rerun a command periodically
alias e='echo'               # Print text
alias r='rg'                 # ripgrep: fast code/text search
alias t='terraform'          # Infrastructure as Code (HashiCorp)
alias y='yq'                 # YAML processor (jq for YAML)
alias u='uname -a'           # System information
#alias i='ip -c a'            # Network addresses (colorized)
alias o='openssl'            # TLS/crypto toolkit
#alias p='ps aux'             # Process status

# Row 2: ASDFGHJKL
#alias a='aws'                # AWS CLI
#alias s='sudo'               # Run command as superuser
alias s='systemctl'          # Run Systemctl command
alias d='docker'             # Containers (Docker)
alias f='find'               # Find files/directories
# alias g='git'                # Version control
# alias h='helm'               # Kubernetes package manager
alias j='journalctl -xe'     # systemd logs (errors/verbose)
# alias k='kubectl'            # Kubernetes CLI
# alias l='ls -lah'            # List files (detailed, human-readable)

# Row 3: ZXCVBNM
alias z='z'                  # zoxide: quick directory jumping (if installed)
#alias x='exit'               # Exit the current shell
alias c='cat'                # Concatenate and print files
alias v='vim'                # Text editor
#alias b='basename'           # Strip directory and suffix
alias n='nano'               # Nano's ANOther text editor, inspired by Pico
alias m='man'                # Display online manual documentation pages

# Kubernetes Aliases
alias kgp='kubectl get pods'
alias kgn='kubectl get nodes'
alias kgs='kubectl get services'
alias kgd='kubectl get deployment'
alias kgrs='kubectl get replicaset'
alias kgds='kubectl get daemonset'
alias kgns='kubectl get namespace'
alias kgcm='kubectl get configmaps'
alias kgi='kubectl get ingress'
alias kga='kubectl get all'
alias ktn='kubectl top nodes'
alias kdp='kubectl describe pod'
alias kdn='kubectl describe node'
alias kds='kubectl describe service'
alias kdrs='kubectl describe replicaset'
alias kdds='kubectl describe daemonset'
alias kdns='kubectl describe namespace'
alias kdcm='kubectl describe configmaps'
alias kdi='kubectl describe ingress'
alias kaf='kubectl apply -f'
alias pf='kubectl port-forward svc/nginx-service 8080:80' # Forward ports for Kubernetes service
alias mk='kubectl config use-context minikube' # Switch to Minikube context
alias kctx='kubectx'
alias kns='kubens'

# Google Cloud Aliases
alias gk='gcloud container clusters get-credentials kubia --zone us-central1-a --project infra-mix-450113-i8'
alias gku='yes | gcloud container clusters resize kubia --node-pool default-pool --num-nodes 1 --zone us-central1-a'
alias gkd='yes | gcloud container clusters resize kubia --node-pool default-pool --num-nodes 0 --zone us-central1-a'
alias g='gcloud' # Shorter alias for Gcloud

# AWS Aliases
alias ak='aws eks update-kubeconfig --region us-east-1 --name my-eks-cluster'

# Database Management Aliases
alias pma='timeout 3600 docker run --rm --name pma -d -e PMA_ARBITRARY=1 -p 8080:80 phpmyadmin' # Launch phpMyAdmin with timeout

# History Aliases
alias hg='history | grep -i --color=auto' # Search command history
alias h='f() { history | tail -"${1:-20}" | awk "{printf \"\033[1;32m%5s\033[0m  %s\n\", \$1, substr(\$0,index(\$0,\$2))}"; }; f' # usage: h [n], default 20

# General Aliases
alias 🍺="git checkout -b drunk" # Fun alias to create a git branch
#alias c='code .' # Open current directory in VSCode
alias reveal-md="reveal-md --theme night --highlight-theme hybrid --port 1337" # Launch Reveal.js slides
alias ns='npm start'
alias nr='npm run'
alias nis='npm i -S'
alias clr='clear' # Clear terminal
alias reload='source ~/.bashrc'

# Listing Aliases
alias ls='ls --color=auto'
alias l='ls -laF' # List files in current directory
alias la='ls -lah'
alias ll='ls -lF'
alias laf='ls -laF'
alias lt='ls -lFt'

# Quick Directory Jumps
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias -- -='cd -'

# System Aliases
alias df='df -h'
alias du='du -h'
alias ut='uptime' # Display system uptime
alias free='free -h'
alias inodes='df -i'
alias sizeroot='sudo du -xhd1 / | sort -h'
alias sizelocal='du -xhd1 . 2>/dev/null | sort -h'
alias whicha='type -a'

# System Information and Processes
alias unamea='uname -a'
alias osrel='cat /etc/os-release'
alias cpuinfo='lscpu'
alias meminfo='free -h'
alias pci='lspci'
alias usb='lsusb'
alias blk='lsblk -f'
alias mountlist='findmnt -A'
alias whoports='ss -tulpen'
alias pst='ps -ef'
alias psg='ps -ef | grep -i'
alias psgrep='ps aux | grep -i'
alias psgit='ps aux | grep -i git'
alias topu='top -o %CPU'

# journalctl/systemctl
alias sc='sudo systemctl'
alias scu='systemctl --user'
alias sst='systemctl status'
alias scs='sudo systemctl status'
alias sce='sudo systemctl enable'
alias scd='sudo systemctl disable'
alias scr='sudo systemctl restart'
alias scstart='sudo systemctl start'
alias scstop='sudo systemctl stop'
alias jl='journalctl -xe'
alias jlf='journalctl -f -u'
alias jbt='journalctl -b'

# Networking and Diagnostics
alias ipa='ip -brief a'
alias ipr='ip -brief r'
alias ifc='ip -c a'
alias pingg='ping -c 5 8.8.8.8'
alias ping1='ping -c 1'
alias mtrg='mtr -rwz 8.8.8.8'
alias digg='dig +short'
alias digs='dig +nocmd +nocomments +noquestion +answer'
alias digmx='dig +short MX'
alias ns='nslookup'
alias whois='whois'
alias curlh='curl -I'
alias dotfiles='curl -fsSL https://raw.githubusercontent.com/iOSSergey/dotfiles/main/install.sh | bash'
#alias myip='curl -s https://api.ipify.org && echo'
#alias myip6='curl -s https://api64.ipify.org && echo'

alias ipt='iptables -L OUTPUT -n -v --line-numbers'
alias p='f() { netstat -tn | grep ":$1 " | awk "{print \$5}" | sed -E "s/^\[?([^]]+)\]?(:[0-9]+)$/\1/" | sort | uniq -c | sort -nr | head -20; }; f' # top IPs by port: p 443

# MTProxy Diagnostics
alias tg="ss -tn '( sport = :4433 )' | awk '{print \$5}' | cut -d: -f1 | sort | uniq"
alias tgcount="ss -tn '( sport = :4433 )' | awk '{print \$5}' | cut -d: -f1 | sort | uniq | wc -l"
alias tgmax="grep \"$(date +%Y-%m-%d)\" /var/log/mtproxy_conn.log | awk '{print \$3}' | sort -nr | head -1"

# Compression and Archives
alias tgz='tar -czf'  # usage: tgz archive.tar.gz files...
alias tbz='tar -cjf'
alias txz='tar -cJf'
alias untar='tar -xvf'
alias ungz='gunzip'
alias unxz='unxz'
alias unbz='bunzip2'
alias zipr='zip -r'
alias unzipq='unzip -q'

# Grep Aliases
alias grep='grep --color=auto --exclude-dir={.git,.hg,.svn,node_modules,dist,build}'

# Timestamps and Date Formats
alias now='date -Iseconds'
alias today='date +"%Y-%m-%d"'
alias week='date +"%G-W%V"'
alias unixts='date +%s'

# Git Aliases
alias ga='git add'
alias gaa='git add .' # Add all changes in current directory
alias gaaa='git add -A' # Add all changes, including deletions
alias gap='git add -p'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gco='git checkout'
alias gcob='git checkout -b' # Create and switch to a new branch
alias gcom='git checkout main' # Switch to main branch
alias gsw='git switch'
alias gs='echo ""; echo "*********************************************"; echo -e "   DO NOT FORGET TO PULL BEFORE COMMITTING"; echo "*********************************************"; echo ""; git status' # Reminder before checking status
alias gss='git status -s' # Short status
alias gd='git diff'
alias gds='git diff --staged'
alias gdt='git difftool'
alias gi='git init'
alias gl='git log --oneline --graph --decorate --all'
alias gll='git log --graph --decorate --all --abbrev-commit --date=relative --format="%C(bold cyan)%h%Creset %C(auto)%d%Creset %C(white)%s %C(green)(%cr) %C(bold blue)<%an>%Creset"'
alias glo='git log --pretty=format:"%h %ad | %s%d [%an]" --date=short'
alias gsh='git show'
alias gblame='git blame -w'
alias gst='git stash'
alias gsta='git stash push'
alias gstp='git stash pop'
alias gsp='git sparse-checkout'
alias gcl='git clone'
alias gc='git commit'
alias gcm='git commit -m' # Commit with message
alias gca='git commit -a -m'
alias gcam='git commit -a -m'
alias gci='git commit'
alias gfixup='git commit --fixup'
alias gpf='git push --force-with-lease'
alias gp='git pull'
alias gpsh='git push'
alias gpl='git pull --ff-only'
alias gpr='git pull --rebase --autostash'
alias grb='git rebase'
alias grc='git rebase --continue'
alias gra='git rebase --abort'
alias grs='git reset'
alias grsh='git reset --hard'
alias grsm='git reset --mixed'
alias grss='git reset --soft'
alias gt='git tag'
alias gtv='git tag -n99'
alias gclean='git clean -fdx'
alias gundo='git reset --soft HEAD~1'
alias ghead='git rev-parse --short HEAD'
alias gsu='git submodule update --init --recursive'

# Docker Aliases
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dcd='docker compose down' # Build, stop, and start Docker Compose
alias dls='docker container ls'
alias dlsa='docker container ls -a'
alias dim='docker images'
alias dprune='docker system prune -f'
alias dlog='docker logs'
alias dlogf='docker logs -f'
alias dsh='docker exec -it'
alias drm='docker rm'
alias drmi='docker rmi'
alias dcp='docker cp'
alias dins='docker inspect'
alias dnet='docker network ls'
alias dvol='docker volume ls'
alias dup='docker compose up'
alias dupd='docker compose up -d'
alias ddown='docker compose down'
alias dbuild='docker compose build'
alias drestart='docker compose restart'
alias dtop='docker top'
alias dstats='docker stats --no-stream'
alias dtag='docker tag'

# Xray Aliases
alias x='f() { docker exec 3x-ui sh -c "grep \"$1\" /app/access.log | tail -80"; }; f' # usage: x 1.2.3.4

# Text Processing Shortcuts
alias sortn='sort -n'
alias sortu='sort -u'
alias uniqc='uniq -c | sort -nr'
alias head10='head -n 10'
alias tail10='tail -n 10'
alias tailf='tail -f'
alias cols='column -t -s,'
alias wcw='wc -w'
alias wcl='wc -l'
alias wcc='wc -c'
alias sedi="sed -i"
alias awkjson='awk -F"[,:}]{1,}" "{for(i=1;i<=NF;i++) print \$i}"'

# Terraform Aliases
alias tf='terraform'
alias tfa='terraform apply -auto-approve'

# GPG Aliases
alias gpglist='gpg --list-secret-keys --keyid-format LONG'
alias gpgenc='gpg --symmetric --cipher-algo AES256'
alias gpgdec='gpg --decrypt'

# Mac-specific aliases
if [ -f /System/Library/CoreServices/SystemVersion.plist ]; then
	alias bs='cd ~/dev/scripts'
	alias s='pmset sleepnow'
	#alias a='nano ~/.bash_{aliases,functions} && source ~/.bash_profile && rsync ~/.bash_{aliases,functions} lobasto:~/' # Edit and reload aliases
	alias a='vi ~/.bash_aliases && source ~/.bash_profile && rsync -avz -e "ssh" ~/.bash_{aliases,functions} jumpbox:~/' # Edit and reload aliases
	alias b='vi ~/.bash_profile && vi ~/.bash_functions && source ~/.bash_profile' # Edit and reload bash profile
	alias xc='logout'		
	alias o="open ." # Open current directory in Finder
	alias reload='source ~/.bash_profile'
	alias g='cd ~/dev/telegram-bots/wireguard-telegram-bot && scp .env carmelia:~/dev/telegram-bots/wireguard-telegram-bot'
	update_vpn2any_bot() {
	    rsync -av \
		--exclude='__pycache__/' \
		~/dev/telegram-bots/vpn2any/ \
		carmelia:~/dev/telegram-bots/vpn2any-telegram-bot/ || return 1

	    ssh carmelia '
		echo "🔁 restarting service"
		systemctl restart vpn2any-telegram-bot || exit 1

		echo "📜 logs"
		journalctl -u vpn2any-telegram-bot -n 10 --no-pager
	    '
	}

        alias up="update_vpn2any_bot"

	#echo "Hello World!"
fi

# =========================
# CarmeliaSpecificAliases
# =========================
if [[ "$(hostname)" == "carmelia" ]]; then

    update_bot() {
        echo "➡️ Updating WireGuard bot on carmelia"

        cd ~/dev/telegram-bots/vpn2any-telegram-bot || return 1

        echo "📥 git pull"
        git pull || return 1

        echo "🔁 restarting service"
        systemctl restart vpn2any-telegram-bot || return 1

        echo "📜 logs (Ctrl+C to exit)"
        journalctl -u vpn2any-telegram-bot -n 10 --no-pager
    }

    alias b="update_bot"
fi

# --------------------------------------------
# Bootstrap & Scripts Setup
# --------------------------------------------
alias setup-scripts='curl -fsSL https://raw.githubusercontent.com/iOSSergey/scripts/main/install.sh | bash'
alias setup-bootstrap='curl -fsSL https://raw.githubusercontent.com/iOSSergey/bootstrap/main/install.sh | sudo bash'

# --------------------------------------------
# End of file marker
# --------------------------------------------
# Tip: run "a" to edit and reload this file quickly.
alias j='ssh jumpbox'
