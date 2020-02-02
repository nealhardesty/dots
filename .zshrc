
[[ -z "$PS1" ]] && return

# Run after .zprofile for all interactive shells
export PATH=${HOME}/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

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

# Completions
autoload -Uz compinit
compinit

# Prompt stuff
if [[ $EUID == 0 ]]; then
  export PS1='%m%~# '
else
  export PS1='%m%~> '
fi

# Change terminal title
chxt() {
  echo -ne "\033]30;$*\007"
}

# https://matt.blissett.me.uk/linux/zsh/zshrc
# Quick ../../.. from https://github.com/blueyed/oh-my-zsh
resolve-alias() {
    # Recursively resolve aliases and echo the command.
    typeset -a cmd
    cmd=(${(z)1})
    while (( ${+aliases[$cmd[1]]} )) \
	      && [[ ${aliases[$cmd[1]]} != $cmd ]]; do
	cmd=(${(z)aliases[${cmd[1]}]})
    done
    echo $cmd
}
rationalise-dot() {
    # Auto-expand "..." to "../..", "...." to "../../.." etc.
    # It skips certain commands (git, tig, p4).
    #
    # resolve-alias is defined in a separate function.

    local MATCH # keep the regex match from leaking to the environment.

    # Skip pasted text.
    if (( PENDING > 0 )); then
	zle self-insert
	return
    fi

    if [[ $LBUFFER =~ '(^|/| ||'$'\n''|\||;|&)\.\.$' ]] \
	   && ! [[ $(resolve-alias $LBUFFER) =~ '(git|tig|p4)' ]]; then
	LBUFFER+=/
	zle self-insert
	zle self-insert
    else
	zle self-insert
    fi
}
zle -N rationalise-dot
bindkey . rationalise-dot
bindkey -M isearch . self-insert 2>/dev/null

# Aliases:
alias ls='ls -F'
alias k=kubectl
alias 'cd..= cd ..'

# Local overrides
if [ -f $HOME/.zshrc.local ]; then
  . $HOME/.zshrc.local
fi
