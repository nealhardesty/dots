#!/bin/bash -x

set -ex

echo  'neal    ALL=(ALL:ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/neal 
sudo chmod 0440 /etc/sudoers.d/neal

# Kill it with fire
sudo dnf remove -y nano
sudo dnf update -y
sudo dnf install -y \
  zsh \
  java-latest-openjdk \
  kernel-devel \
  python3 \
  tmux \
  git \
  openssh-server \
  vim \
  samba \
  cifs-utils \
  wget \
  curl \
  jq \
  net-tools \
  dnsutils \
  nmap \
  htop \
  nmon \
  rsync \
  autossh 

$(dirname $0)/install-ubuntu-golang.sh

$(dirname $0)/install-git-settings.sh

# junk directories
(cd ~ && rmdir Documents/ Music/ Pictures/ Public/ Templates/ Videos/ || true)
