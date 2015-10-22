#!/bin/bash

# JAVA_HOME
#export JAVA_HOME=/opt/jdk

export ANDROID_HOME="~/bin/android-sdk"

# path
export PATH="~/bin:/usr/local/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$JAVA_HOME/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:/opt/idea/bin:/usr/games"

export EDITOR=vim
export VISUAL=vim

# GO stuff
export GOROOT=/usr/local/go
export GOPATH=$HOME/gocode/
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
HNAME=$(echo $HOSTNAME | tr '[A-Z]' '[a-z]')

# Machine specific customizations
case "$HNAME" in
	marmot) 
		txtcolor=$txtbold$txtyellow
		#emoji cat
		if [ -z "$SSH_CONNECTION" ]; then HNAME="🐱 "; fi
		;;
	bear|otter)
		txtcolor=$txtbold$txtgreen
		;;
	whistlepig|pig|badger)
		txtcolor=$txtbold$txtpurple
		PS1BASE="\u$txtcolor@$HNAME$txtreset\w ^^^oo_ "
		;;
	moose|mooses|walrus)
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
			chxt "${HNAME}:${PWD}"
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
alias bear="ssh -p 2222 -L 3389:192.168.1.11:3389 neal@bear.roadwaffle.com"
alias marmot="ssh -p 22 -L 3389:192.168.1.11:3389 neal@marmot.roadwaffle.com"
alias walrus="rdesktop -m -z -g 1280x768 -u neal localhost -p $PASS1 2> /dev/null "
#alias marmotvnc="vncviewer -encodings 'copyrect tight hextile zlib corre rre raw' -quality 0 localhost:5900"
alias emacs="emacs -nw"
alias otter="ssh -p 2345 neal@badger.roadwaffle.com"
