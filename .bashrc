#!/bin/bash

# JAVA_HOME
#export JAVA_HOME=/opt/jdk

export ANDROID_HOME="~/bin/android-sdk"

# path
export PATH="~/bin:/usr/local/bin:~/.rvm/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$JAVA_HOME/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:/opt/idea/bin:/usr/games:/snap/bin:/usr/local/go/bin"

if [ $(uname) == "Darwin" ]; then
  PATH="~/Dropbox/macbin:$PATH"
elif [ $(uname) == "Linux" ]; then
  PATH="~/Dropbox/bin:$PATH"
fi

#[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
if [ -f ~/.rvm/scripts/rvm ]; then
	source ~/.rvm/scripts/rvm
fi

export EDITOR=vim
export VISUAL=vim

# GO stuff
# homebrew install location: /usr/local/opt/go/libexec/bin
#export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin:$GOPATH

# if not interactive, leave now
[[ ! $- =~ i ]] && return

# check the window size after each command
shopt -s checkwinsize

# auto set remote display
if [ -z "$DISPLAY" ]; then
  export DISPLAY=`who am i|awk '{print $5}'|sed -e 's/[\(\)]//g'`:0.0
fi

tput init

# some text colors
txtbold=$(tput bold)
txtunderline=$(tput sgr 0 1)
txtreset=$(tput sgr0)
txtred=$(tput setaf 1)
txtgreen=$(tput setaf 2)
txtyellow=$(tput setaf 3)
txtblue=$(tput setaf 4)
txtpurple=$(tput setaf 5)
txtlightblue=$(tput setaf 6)
txtwhite=$(tput setaf 7)

#HNAME=${HOSTNAME,,}
HNAME=$(echo $HOSTNAME | tr '[A-Z]' '[a-z]' | cut -d '.' -f 1)

# Animals: 🐱 🐙 🐿 🐽 🐻 🐳 🐮 🐯 🐷 🐭 🐢 🐝 🐡 🐠 🐞 🐟 🐘 🐌 🐊 🐈 🐉 🦃 🦁 🦀
# Symbols: ᚬ ☠ 💩 💥 👾 🤖 🤓 👀 ⎇ » ▶ « ◀ 
# Kubernetes: ⚙ ⎈

# prompt
function setPS1 {
  PCHAR=""
  #case "$HNAME" in 
  #  marmot*) PCHAR="🐯 " ;;
  #  bear*) PCHAR="🐻 " ;;
  #  otter*) PCHAR="🐱 " ;;
  #  turkey*) PCHAR="🦃 " ;;
  #  *) PCHAR="👾 " ;;
  #esac
  #if [[ "$EUID" = 0 ]]; then 
  #    PCHAR=" ☠" 
  #fi
  #if [[ "$LAST_EXITCODE" -gt 0 ]]; then 
  #  PCHAR=" 💥" 
  #fi
  if [[ "$EUID" = 0 ]]; then
    #LEFT="###"
    #RIGHT="###"
    LEFT=""
    RIGHT="###"
  else
    #LEFT="("
    #RIGHT=")"
    LEFT=""
    RIGHT=">"
  fi

	export PS1="\[$txtwhite\]$LEFT\[$txtreset\]\[$txtpurple\]\u\[$txtreset\]@\[$txtgreen$txtbold\]$HNAME\[$txtreset\] $KUBERNETES_CURRENT_NAMESPACE$GIT_CURRENT_BRANCH\[$txtlightblue\]\w\[$txtreset\]$PCHAR\[$txtwhite\]$RIGHT\[$txtreset\] "
}

function chxt {
	echo -ne "\033]0;$*\007"
}

function setWindowTitle {
	case "$TERM" in
		xterm*|rxvt*|screen*|tmux*)
			if [ "$TITLE" ]; then
				chxt "$TITLE"
			else
				chxt "${HNAME}:${PWD}"
			fi
			;;
		*)
			;;
	esac
}

function getKubeNamespace {
  which kubectl > /dev/null 2>&1 || return
  KUBERNETES_CURRENT_NAMESPACE=""
  if [[ -f $HOME/.kube/config && $EUID != 0 ]]; then
    current_context=$(kubectl config current-context)
    current_namespace=$(kubectl config get-contexts $current_context |grep '^*' |awk '{print $5}')
    if [[ "$?" -eq 0 && "$current_namespace" != "default" ]]; then
      KUBERNETES_CURRENT_NAMESPACE="⎈\[$txtyellow\]$current_context:$current_namespace\[$txtreset\] "
    fi
  fi
}

function getGitBranchString {
  GIT_CURRENT_BRANCH=""
  if [ $EUID != 0 ]; then
    branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    if [[ "$?" -eq 0 ]]; then
      GIT_CURRENT_BRANCH="⎇\[$txtred\]$branch\[$txtreset\] "
    fi
  fi
}

function promptCommand {
  LAST_EXITCODE=$?
  getKubeNamespace
	getGitBranchString
	setWindowTitle
	setPS1
}
PROMPT_COMMAND="promptCommand"

setPS1



#Eclipse mouse button click fix - may not be required anymore
export GDK_NATIVE_WINDOWS=true

export AWS_PROFILE=default

export AUTOSSH_PORT=0

set -o emacs

if [ -f ~/.pass ]; then
	PASS1=$(cat ~/.pass)
else
	PASS1=""
fi


alias pd="pushd"
alias p="popd"

alias ls="ls -F"

alias k=kubectl

alias bc='bc -l'

alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'

alias oplogin='eval $(op signin my)'

alias ff="firefox"
alias chrome="google-chrome-stable"


alias ports="sudo netstat -tulanp"

#alias kindconfig="export KUBECONFIG=$(kind get kubeconfig-path)"
#alias kindinit="kind create cluster && export KUBECONFIG=$(kind get kubeconfig-path) && kubectl --context=kubernetes-admin@kind && get ns && kubectl --context=kubernetes-admin@kind create serviceaccount tiller && kubectl --context=kubernetes-admin@kind create clusterrolebinding tiller --serviceaccount=kube-system:tiller --clusterrole=cluster-admin && helm --kube-context=kubernetes-admin@kind init --service-account tiller"

if [ -f ~/.bashrc.local ]; then
	source ~/.bashrc.local
fi
if [ -f "$HOME/.cargo/env" ]; then
  source "$HOME/.cargo/env"
fi
