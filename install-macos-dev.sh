#!/bin/bash

set -e

cd $(dirname $0)

# Add me to the sudoers explicitly
sudo grep $(whoami) /etc/sudoers >> /dev/null || echo  $(whoami)'    ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers

# Install the xcode cli tools
echo Triggering xcode tools install...
xcode-select --install || echo xcode tools not installed

# Force accept the xcode cli license agreement
sudo xcodebuild -license accept


./install-macos-homebrew.sh

./install-macos-rosetta2.sh

./install-macos-homebrew-amd64.sh

brew install tmux yq wget rar socat python3 openssl go coreutils autossh htop nmap gcc tailscale || echo some packages not installed

brew install --cask iterm2 hammerspoon docker visual-studio-code firefox vlc adoptopenjdk xquartz slack skype zoomus github kindle viscosity alt-tab google-drive parsec google-chrome  || echo some casks not installed

#brew install --cask install wine-stable wireshark inkscape macdown joplin aerial vmware-fusion parallels datagrip veracrypt spotify jump 1password evernote dropbox

# General git setup
./install-git-settings.sh
