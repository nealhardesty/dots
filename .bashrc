#!/bin/bash

# JAVA_HOME
#export JAVA_HOME=/opt/jdk

export ANDROID_HOME="~/bin/android-sdk"

# path
export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$JAVA_HOME/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin:~/bin:~/bin/eclipse:~/bin/node/bin:/usr/NX/bin:/opt/idea/bin:/usr/games"

# GO stuff
export GOROOT=/usr/local/go
export GOPATH=~/dev/go
export PATH=$PATH:$GOROOT/bin:$HOME/go

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
		txtcolor=$txtbold$txtpurple
		#emoji cat
		if [ -z "$SSH_CONNECTION" ]; then HNAME="🐱 "; fi
		;;
	bear)
		txtcolor=$txtbold$txtgreen
		;;
	whistlepig|pig)
		txtcolor=$txtbold$txtblue
		PS1BASE="\u$txtcolor@$HNAME$txtreset\w ^^^oo_ "
		;;
	nhardesty-wsl|badger|whistlepig|otter)
		txtcolor=$txtbold$txtpurple
		;;
	moose|mooses|walrus)
		txtcolor=$txtbold$txtred
		;;
	*)
		txtcolor=$txtbold
		;;
esac


# prompt
if [ $EUID = 0 ]; then
	export PS1="\u$txtcolor@$HNAME$txtreset\w# "
else
	if [ -z "$PS1BASE" ]; then
		PS1="\u$txtcolor@$HNAME$txtreset\w> "
	else
		PS1="$PS1BASE"
	fi
fi


case "$TERM" in
	xterm*|rxvt*|screen*)
    PROMPT_COMMAND='echo -ne "\033]0;${HNAME}:${PWD}\007"'
    ;;
	*)
    ;;
esac


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

alias ls="ls -F"
alias bear="ssh -p 2222 -L 3390:192.168.1.11:3389 neal@bear.roadwaffle.com"
alias owl="ssh -p 22 -L 3390:192.168.1.11:3389 neal@owl.roadwaffle.com"
alias walrus="rdesktop -m -z -g 1280x768 -u neal localhost -p $PASS1 2> /dev/null "
#alias marmotvnc="vncviewer -encodings 'copyrect tight hextile zlib corre rre raw' -quality 0 localhost:5900"
