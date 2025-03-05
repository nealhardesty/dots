# See http://zsh.sourceforge.net/Doc/Release/Options.html
[[ -z "$PS1" ]] && return

# Extra environment
export AWS_PROFILE=default
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export COMPOSE_PROFILES=all

# Run after .zprofile for all interactive shells
export PATH=${HOME}/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/snap/bin:$GOROOT/bin:$GOPATH/bin:$GOPATH


# Options follow - https://linux.die.net/man/1/zshoptions

# Do not immediately notify on subprocess exit
setopt NO_NOTIFY

# Do not send HUP on shell exit
setopt NO_HUP
setopt AUTO_CONTINUE

# Do Not use >! instead of clobbering on file redirect
setopt CLOBBER

# Do not nice background processes
setopt NO_BG_NICE

# Confirm after rm *
#setopt RM_STAR_WAIT
#http://zsh.sourceforge.net/Doc/Release/Options.html#index-RM_005fSTAR_005fSILENT
setopt RM_STAR_SILENT

# Shut up
setopt NO_BEEP

# Automaticaly Change Directory
setopt AUTO_CD

# cd is pushd as well
setopt AUTO_PUSHD
# pushd prints nothing
setopt PUSHD_SILENT
# allow pushd to just push home
setopt PUSHD_TO_HOME
# remove directory history duplicates
setopt PUSHD_IGNORE_DUPS
# dirs -v | ~# is cool
alias d='dirs -v |head -20'
alias 1='cd ~1'
alias 2='cd ~2'
alias 3='cd ~3'
alias 4='cd ~4'
alias 5='cd ~5'
alias 6='cd ~6'
alias 7='cd ~7'
alias 8='cd ~8'
alias 9='cd ~9'

# Just list the choices
setopt AUTO_LIST
setopt BASH_AUTO_LIST

# automatically cycle through directories on second tab
# don't like it, turn it off
setopt NO_AUTO_MENU

# don't drop the final /
setopt NO_AUTO_REMOVE_SLASH

# GLOB_COMPLETE - allow '*' etc to complete (with menu)
setopt GLOB_COMPLETE

# extended glob matches 
setopt extendedglob

# Don't complain about no glob matches
unsetopt nomatch

setopt LIST_TYPES

# History options
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=~/.zhistory
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

# Set this if you want a unified history between shells
setopt NO_SHARE_HISTORY
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
# More animals: see emoji.md
# Symbols: ᚬ ☠ 💩 💥 👾 🤖 🤓 👀 ⎇ » ▶ « ◀ 
# Kubernetes: ⚙ ⎈
#
#


function setHostPrompt {
  HOSTPROMPT=$(hostname -s)
  return
  # Disabling for now
  case "${HOSTPROMPT}" in
    moose*)
      HOSTPROMPT="🦌"
      ;;
    moose*)
      HOSTPROMPT="🦌"
      ;;
    (#i)otter*)
      HOSTPROMPT="🦦"
      ;;
    marmot*)
      HOSTPROMPT="🐿" # Yes, that's really a chipmunk
      ;;
    bearx)
      HOSTPROMPT="🐻x" 
      ;;
    bear*)
      HOSTPROMPT="🐻" 
      ;;
    badger*)
      HOSTPROMPT="🦡"
      ;;
    skunk*)
      HOSTPROMPT="🦨"
      ;;
    turkey*)
      HOSTPROMPT="🦃"
      ;;
    owl*)
      HOSTPROMPT="🦉"
      ;;
    turtle*)
      HOSTPROMPT="🐢"
      ;;
    *)
      ;;
  esac
}
setHostPrompt

function getGitBranchString {
  GIT_CURRENT_BRANCH=""
  if [ $EUID != 0 ]; then
    branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    if [[ "$?" -eq 0 ]]; then
      #GIT_CURRENT_BRANCH="%F{grey}[%K{blue}%f%B⎇%b %F{green}${branch}%k%F{grey}]%f"
      GIT_CURRENT_BRANCH="%F{grey}[%K{blue}%f%Bgit:%b%F{green}${branch}%k%F{grey}]%f"
    fi
  fi
}

function getKubeNamespaceString {
  KUBERNETES_CURRENT_NAMESPACE=""
  which kubectl >> /dev/null 2>&1 || return
  if (uname -r |grep -i microsoft >/dev/null 2>&1); then
    # Too slow in WSL ¯\_(ツ)_/¯
    return
  fi
  if [[ -f $HOME/.kube/config && $EUID != 0 ]]; then
    current_context=$(kubectl config current-context 2>/dev/null)
    if [ $? -ne 0 ]; then 
      return
    fi
    current_namespace=$(kubectl config get-contexts $current_context 2>/dev/null |grep '^*' |awk '{print $5}')
    if [ $? -ne 0 ]; then 
      return
    fi
    #if [[ "$?" -eq 0 && "$current_namespace" != "default" ]]; then
    if [[ "$current_context" =~ "^prod" ]]; then
      #KUBERNETES_CURRENT_NAMESPACE="%F{grey}[%K{yellow}%f%B⎈%b%F{red}${current_context}:${current_namespace}%k%F{grey}]%f"
      KUBERNETES_CURRENT_NAMESPACE="%F{grey}[%K{yellow}%f%Bk8s:%b%F{red}${current_context}:${current_namespace}%k%F{grey}]%f"
    else
      #KUBERNETES_CURRENT_NAMESPACE="%F{grey}[%K{blue}%B⎈%b%F{green}${current_context}:${current_namespace}%k%F{grey}]%f"
      KUBERNETES_CURRENT_NAMESPACE="%F{grey}[%K{blue}%Bk8s:%b%F{green}${current_context}:${current_namespace}%k%F{grey}]%f"
    fi
  fi
}

precmd() {
  local last_exit=$?
	getGitBranchString
	getKubeNamespaceString
  HOSTPROMPT=$(echo "${HOSTPROMPT}" | tr '[:upper:]' '[:lower:]')
	#export PS1='%F{magenta}%n%f@%B%F{blue}%m%b %F{green}%~%(!.%F{red}#.%F{white}>)%f '
	export PS1='%B%F{blue}'${HOSTPROMPT}'%b %F{green}%~%(!.%F{red}#.%F{white}>)%f '
	export RPS1="%(?..%F{grey}[%B%F{red}${last_exit}%b%F{grey}]%f )${GIT_CURRENT_BRANCH} ${KUBERNETES_CURRENT_NAMESPACE}"
}

# Change terminal title
chxt() {
  echo -ne "\033]30;$*\007"
}

if [[ -e /proc/sys/fs/binfmt_misc/WSLInterop ]]; then
  # WSL
  alias c="clip.exe"
  alias p="powershell.exe Get-Clipboard"

  alias clip.exe='/mnt/c/Windows/System32/clip.exe'
  alias code='/mnt/c/Program\ Files/Microsoft\ VS\ Code/bin/code'
elif [[ $(uname) = "Darwin" ]]; then
  # MAC
  alias c="pbcopy"
  alias p="pbpaste"
else
  # LINUX
  alias c="xclip -sel clip"
  alias p="xclip -sel clip -o"
fi

# Aliases:
alias ls='ls -F'
alias k=kubectl
alias 'cd..= cd ..'
alias '..= cd ..'
alias '...= cd ...'
alias '....= cd ....'
alias '.....= cd .....'
alias '......= cd ......'


# Suffix Aliases
alias -s {yml,yaml}=vim

# Global Aliases
alias -g G='|grep -i'

# Local overrides
if [ -f $HOME/.zshrc.local ]; then
  . $HOME/.zshrc.local
fi
