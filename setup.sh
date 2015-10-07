#!/bin/bash

GITREPO=$(cd $(dirname $0); pwd)

find $GITREPO -depth 1 \! -name '.git' \! -name '.ssh' -name '.*' -exec ln -sfv {} ~ \;

mkdir -p ~/.ssh
ln -sfv $GITREPO/.ssh/config ~/.ssh/config

if [ $(uname) = "Darwin" ]; then
	ln -sfv ~/.tmux.conf.mac ~/.tmux.conf
else
	ln -sfv ~/.tmux.conf.linux ~/.tmux.conf
fi
