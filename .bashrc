#!/bin/bash

# JAVA_HOME
#export JAVA_HOME=/opt/jdk

export ANDROID_HOME="~/bin/android-sdk"

# path
export PATH="~/bin:/usr/local/bin:~/.rvm/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$JAVA_HOME/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:/opt/idea/bin:/usr/games"

#[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
if [ -f ~/.rvm/scripts/rvm ]; then
	source ~/.rvm/scripts/rvm
fi

export EDITOR=vim
export VISUAL=vim

# GO stuff
# homebrew install location: /usr/local/opt/go/libexec/bin
export GOROOT=/usr/local/go
export GOPATH=$HOME/go/
mkdir -p $GOPATH
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# if not interactive, leave now
[[ ! $- =~ i ]] && return

# check the window size after each command
shopt -s checkwinsize

# auto set remote display
if [ -z "$DISPLAY" ]; then
        export DISPLAY=`who am i|awk '{print $5}'|sed -e 's/[\(\)]//g'`:0.0
fi

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

# Machine specific customizations
# More emoticons: ☠ 🐱 🐙 👀 🐿 🐽 🐻 🐳 🐮 🐯 🐷 🐭 🐢 🐝 🐡 🐠 🐞 🐟 🐘 🐌 🐊 🐈 🐉 💩 💥 👾 
case "$HNAME" in
	marmot*) 
		txtcolor=$txtbold$txtyellow
		#emoji cat
		if [ -z "$SSH_CONNECTION" ]; then HNAME="🐱 "; fi
		;;
	bear*|otter*)
		txtcolor=$txtbold$txtgreen
		;;
	whistlepig*|pig*|badger*|woodchuck*)
		txtcolor=$txtbold$txtpurple
		PS1BASE="\u$txtcolor@$HNAME$txtreset\w ^^^oO_ "
		;;
	moose*|mooses*|walrus*)
		txtcolor=$txtbold$txtred
		;;
	*)
		txtcolor=$txtbold
		;;
esac

# prompt
function setPS1 {
	if [ $EUID = 0 ]; then
		export PS1="\u$txtcolor@$HNAME$txtreset\w# "
	else
		if [ -z "$PS1BASE" ]; then
			PS1="$GIT_CURRENT_BRANCH\u$txtcolor@$HNAME$txtreset\w> "
		else
			PS1="$GIT_CURRENT_BRANCH$PS1BASE"
		fi
	fi
}

function chxt {
			echo -ne "\033]0;$*\007"
}

function setWindowTitle {
	case "$TERM" in
		xterm*|rxvt*|screen*)
			#PROMPT_COMMAND='echo -ne "\033]0;${HNAME}:${PWD}\007"'
			#echo -ne "\033]0;${HNAME}:${PWD}\007"
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

function getGitInfo {
  GIT_CURRENT_BRANCH=""
  if [ $EUID != 0 ]; then
    GIT_CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
  else
    GIT_CURRENT_BRANCH=""
  fi
  if [ \! -z "$GIT_CURRENT_BRANCH" ]; then
    GIT_CURRENT_BRANCH="[$txtred$GIT_CURRENT_BRANCH$txtreset] "
  fi
	setPS1
}

function promptCommand {
	getGitInfo
	setWindowTitle
	setPS1
}
PROMPT_COMMAND="promptCommand"

setPS1



#Eclipse mouse button click fix - may not be required anymore
export GDK_NATIVE_WINDOWS=true

set -o emacs

if [ -f ~/.pass ]; then
	PASS1=$(cat ~/.pass)
else
	PASS1=""
fi

if [ -f ~/.bashrc.local ]; then
	source ~/.bashrc.local
fi

alias pd="pushd"
alias p="popd"

alias ls="ls -F"
alias emacs="emacs -nw"
alias marmot="autossh -M 0 -L 3390:192.168.1.11:3389 -L 3391:192.168.1.12:3389 -t neal@marmot.roadwaffle.com 'tmux attach || tmux new'"
