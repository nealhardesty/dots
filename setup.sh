#!/bin/bash

GITREPO=$(cd $(dirname $0); pwd)

#find $GITREPO -maxdepth 1 -type f -name '.*' -exec echo {}  \;
find $GITREPO -maxdepth 1 \! -name .gitignore -type f -name '.*' -exec ln -sfv {} ~ \;

#(cd $GITREPO/.vim && git clone https://github.com/scrooloose/nerdtree)

ln -sf $GITREPO/.vim ~/.vim


mkdir -p ~/.ssh
ln -sfv $GITREPO/.ssh/config ~/.ssh/config

mkdir -p ~/bin
