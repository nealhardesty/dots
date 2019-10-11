#!/bin/bash



echo Installing Homebrew...
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install tmux yq wget unrar socat python3 openssl go coreutils autossh gor htop nmap

brew cask install macdown hammerspoon docker dropbox


