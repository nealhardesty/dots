#!/bin/bash



echo Installing Homebrew...
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install tmux yq wget unrar socat python3 openssl go coreutils autossh gor htop nmap

brew cask install iterm2 hammerspoon docker dropbox visual-studio-code firefox brave-browser 1password 1password-cli jetbrains-toolbox vlc evernote adoptopenjdk xquartz slack skype zoomus github kindle viscosity

#brew cask install wine-stable wireshark inkscape macdown joplin aerial vmware-fusion parallels datagrip veracrypt spotify jump


