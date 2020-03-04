
[[ -z "$PS1" ]] && return

# Run after .zprofile for all interactive shells
export PATH=${HOME}/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/snap/bin

# Do not immediately notify on subprocess exit
setopt NO_NOTIFY

# Do not send HUP on shell exit
setopt NO_HUP
setopt AUTO_CONTINUE

# Use >! instead of clobbering on file redirect
setopt NOCLOBBER

# Do not nice background processes
setopt NO_BG_NICE

# Confirm after rm *
setopt RM_STAR_WAIT

# Shut up
setopt NO_BEEP

# Automaticaly Change Directory
setopt AUTO_CD

# History options
export HISTSIZE=2000
export SAVEHIST=2000
export HISTFILE=~/.zhistory
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST

# Some defaults
export EDITOR="vi"
export PAGER="less"
export VISUAL=$EDITOR
#bindkey -v
# Too used to emacs keybindings for now...
bindkey -e

# Completions
autoload -Uz compinit
compinit

# Prompt stuff

# Animals: 🐱 🐙 🐿  🐽 🐻 🐳 🐮 🐯 🐷 🐭 🐢 🐝 🐡 🐠 🐞 🐟 🐘 🐌 >🐊 🐈 🐉 🦃 🦁 🦀
# Symbols: ᚬ ☠ 💩 💥 👾 🤖 🤓 👀 ⎇ » ▶ « ◀ 
# Kubernetes: ⚙ ⎈

function getGitBranchString {
  GIT_CURRENT_BRANCH=""
  if [ $EUID != 0 ]; then
    branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    if [[ "$?" -eq 0 ]]; then
      GIT_CURRENT_BRANCH="%F{grey}[%K{blue}%f%B⎇%b %F{green}${branch}%k%F{grey}]%f"
    fi
  fi
}

function getKubeNamespaceString {
  KUBERNETES_CURRENT_NAMESPACE=""
  if [[ -f $HOME/.kube/config && $EUID != 0 ]]; then
    current_context=$(kubectl config current-context)
    current_namespace=$(kubectl config get-contexts $current_context |grep '^*' |awk '{print $5}')
    #if [[ "$?" -eq 0 && "$current_namespace" != "default" ]]; then
    if [[ "$?" -eq 0 ]]; then
      if [[ "$current_context" =~ "^prod" ]]; then
        KUBERNETES_CURRENT_NAMESPACE="%F{grey}[%K{yellow}%f%B⎈%b%F{red}${current_context}:${current_namespace}%k%F{grey}]%f"
      else
        KUBERNETES_CURRENT_NAMESPACE="%F{grey}[%K{blue}%B⎈%b%F{green}${current_context}:${current_namespace}%k%F{grey}]%f"
      fi
    fi
  fi
}

precmd() {
  local last_exit=$?
	getGitBranchString
	getKubeNamespaceString
	export PS1='%F{magenta}%n%f@%B%F{blue}%m%b %F{green}%~%(!.%F{red}#.%F{white}>)%f '
	export RPS1="%(?..%F{grey}[%B%F{red}${last_exit}%b%F{grey}]%f )${GIT_CURRENT_BRANCH} ${KUBERNETES_CURRENT_NAMESPACE}"
}

# Change terminal title
chxt() {
  echo -ne "\033]30;$*\007"
}

# Extra environment
export AWS_PROFILE=default
export GOROOT=/usr/local/go
export GOPATH=$HOME/go:.

# Aliases:
alias ls='ls -F'
alias k=kubectl
alias 'cd..= cd ..'
alias '..= cd ..'
alias '...= cd ...'
alias '....= cd ....'
alias '.....= cd .....'
alias '......= cd ......'

# Local overrides
if [ -f $HOME/.zshrc.local ]; then
  . $HOME/.zshrc.local
fi
