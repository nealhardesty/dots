#!/bin/bash -x

set -ex

echo  'neal    ALL=(ALL:ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/neal 
sudo chmod 0440 /etc/sudoers.d/neal

sudo apt update
# Kill it with fire
sudo apt remove -y nano
sudo apt install -y \
  zsh \
  openjdk-17-jdk \
  build-essential \
  python3 \
  python3-pip \
  python3-venv \
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
  apt-transport-https \
  ca-certificates \
  software-properties-common \
  autossh \
  openvpn

$(dirname $0)/install-ubuntu-golang.sh

#sudo pip3 install --upgrade pip
#sudo pip3 install awscli

#setxkbmap -option caps:swapescape

# Install firefox
#$(dirname $0)/install-ubuntu-firefox.sh

# Install Chrome
#$(dirname $0)/install-ubuntu-chrome.sh

# Install Slack
#$(dirname $0)/install-ubuntu-slack.sh

# Install Kubectl/Helm3
#$(dirname $0)/install-ubuntu-kubectl.sh
#$(dirname $0)/install-ubuntu-helm3.sh

# Install vscode
#$(dirname $0)/install-ubuntu-vscode.sh

$(dirname $0)/install-git-settings.sh

# Docker time
#source $(dirname $0)/install-ubuntu-docker.sh

# Don't need no fancy login manager
#sudo systemctl set-default multi-user.target


# junk directories on ubuntu
(cd ~ && rmdir Documents/ Music/ Pictures/ Public/ Templates/ Videos/ || true)
