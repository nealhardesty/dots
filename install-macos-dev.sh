#!/bin/bash

set -e

echo Triggering xcode tools install...
git --help

echo Installing Homebrew...
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

#git -C /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core fetch --unshallow
#brew update

brew install tmux yq wget rar socat python3 openssl go coreutils autossh gor htop nmap

brew install --cask iterm2 hammerspoon docker visual-studio-code firefox brave-browser 1password-cli jetbrains-toolbox vlc adoptopenjdk xquartz slack skype zoomus github kindle viscosity alt-tab google-drive parsec google-chrome viscosity

#brew install --cask install wine-stable wireshark inkscape macdown joplin aerial vmware-fusion parallels datagrip veracrypt spotify jump 1password evernote dropbox

$(dirname $0)/install-git-settings.sh
