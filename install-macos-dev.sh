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

brew install tmux yq wget rar socat python3 openssl go coreutils autossh htop nmap gcc || echo some packages not installed

brew install --cask iterm2 || echo iterm2 did not install
brew install --cask hammerspoon || echo hammerspoon did not install
brew install --cask docker || echo docker did not install
brew install --cask visual-studio-code || echo visual-studio-code did not install
brew install --cask firefox || echo firefox did not install
brew install --cask vlc || echo vlc did not install
brew install --cask xquartz || echo xquartz did not install
brew install --cask slack || echo slack did not install
brew install --cask github || echo github did not install
brew install --cask google-drive || echo google-drive did not install
brew install --cask google-chrome || echo google-chrome did not install

#brew install --cask install wine-stable wireshark inkscape macdown joplin aerial vmware-fusion parallels datagrip veracrypt spotify jump 1password evernote dropbox zoom alt-tab

# General git setup
./install-git-settings.sh
