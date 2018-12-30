#!/bin/bash

GITREPO=$(cd $(dirname $0); pwd)

#find $GITREPO -maxdepth 1 -type f -name '.*' -exec echo {}  \;
find $GITREPO -maxdepth 1 \! -name .gitignore -type f -name '.*' -exec ln -sfv {} ~ \;

rm -rf ~/.vim
ln -sfv $GITREPO/.vim ~/.vim
#(mkdir -p $GITREPO/.vim/bundle && cd $GITREPO/.vim/bundle/ && rm -rf nerdtree && git clone https://github.com/scrooloose/nerdtree)

rm -rf ~/.i3
ln -sfv $GITREPO/.i3 ~/.i3

touch ~/.bashrc.local


mkdir -p ~/.ssh
if [ -f ~/.ssh/config ]; then
	echo Cowardly refusing to overwrite .ssh/config
else
	ln -sfv $GITREPO/.ssh/config ~/.ssh/config
fi

mkdir -p ~/bin
