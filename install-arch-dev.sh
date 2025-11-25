#!/bin/bash

set -ex

# Disable sudo password for current user
echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER
sudo chmod 0440 /etc/sudoers.d/$USER

# Update system
sudo pacman -Syu --noconfirm

sudo paru -S --noconfirm vim zsh tmux git wget curl jq rsync autossh htop nmon go

paru -S --noconfirm google-chrome

$(dirname $0)/install-git-settings.sh



# junk directories
(cd ~ && rmdir Documents/ Music/ Pictures/ Public/ Templates/ Videos/ || true)
