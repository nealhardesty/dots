#!/bin/bash

# path
export PATH="$PATH:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin:~/bin:~/bin/eclipse:~/bin/node/bin"

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
		txtcolor=$txtbold$txtblue
		#emoji cat
		if [ -z "$SSH_CONNECTION" ]; then HNAME="🐱 "; fi
		;;
	bear|walrus)
		txtcolor=$txtbold$txtgreen
		;;
	nhardesty-wsl|moose)
		txtcolor=$txtbold$txtpurple
		;;
	otter|duck)
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
	export PS1="\u$txtcolor@$HNAME$txtreset\w> "
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

alias ls="ls -F"
alias otter="ssh 192.168.1.42"
alias marmot-ubu="ssh 192.168.1.13"
#alias open="xdg-open"
alias bear="ssh -p 2222 -L 3390:192.168.1.20:3389 neal@roadwaffle.dyndns.org"
alias walrus="rdesktop -m -z -g 1280x1024 -P -u neal localhost -p $(cat ~/.pass) 2> /dev/null "
#alias otter="rdesktop -m -z -g 1280x1024 -P -u neal localhost:3390 -p $(cat ~/.pass) 2> /dev/null "
alias moose="rdesktop -m -z -g 1280x1024 -P -u neal localhost:3390 -p $(cat ~/.pass) 2> /dev/null "
#alias otterwinvnc="vncviewer -encodings Tight -quality 0 localhost:5901"
#alias otterwin="rdesktop -m -z -g 1280x1024 -P -u neal localhost:3391 -p $(cat ~/.pass) 2> /dev/null "
#alias otter="vncviewer -encodings Tight -p ~/.pass -quality 4 localhost:5900"
alias marmotvnc="vncviewer -encodings 'copyrect tight hextile zlib corre rre raw' -quality 0 localhost:5900"

