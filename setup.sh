#!/bin/bash

GITREPO=$(cd $(dirname $0); pwd)

find $GITREPO -maxdepth 1 \! -name .gitignore -type f -name '.*' -exec cp -rfv {} ~ \;
#find $GITREPO -maxdepth 1 \! -name .gitignore -type f -name '.*' -exec ln -sfv {} ~ \;

mkdir -p ~/bin
cp -rv bin/* ~/bin/


mkdir -p ~/.config
cp -rvf ${GITREPO}/.config/* ~/.config/

rm -rv ~/.vim
cp -rfv $GITREPO/.vim ~/.vim
#(mkdir -p $GITREPO/.vim/bundle && cd $GITREPO/.vim/bundle/ && rm -rf nerdtree && git clone https://github.com/scrooloose/nerdtree)

rm -rf ~/.i3
cp -rfv $GITREPO/.i3 ~/.i3

touch ~/.bashrc.local

if [ $(uname) == "Darwin" ]; then
  echo Must be a mac, installing hammerspoon config
  cp -rfv $GITREPO/.hammerspoon ~/.hammerspoon
fi


mkdir -p ~/.ssh
if [ -f ~/.ssh/config ]; then
  echo Cowardly refusing to overwrite .ssh/config
else
  cp -rfv $GITREPO/.ssh/config ~/.ssh/config
  #ls -1 ~/.ssh/id_rsa ~/.ssh/*.pem |xargs -I{} -n 1 echo IdentityFile={} | tee -a ~/.ssh/config.local
fi

mkdir -p ~/go/bin ~/go/src ~/go/internal ~/go/vendor

mkdir -p ~/.ssh
#curl https://api.github.com/users/nealhardesty/keys |jq '.[].key'> ~/.ssh/authorized_keys
