#!/bin/bash -x

echo  'neal    ALL=(ALL:ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/neal 
sudo chmod 0440 /etc/sudoers.d/neal

sudo apt update
# Kill it with fire
sudo apt remove -y nano
sudo apt install -y \
  zsh \
  openjdk-11-jdk \
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

sudo pip3 install --upgrade pip
sudo pip3 install awscli

#setxkbmap -option caps:swapescape

# Install firefox
$(dirname $0)/install-ubuntu-firefox.sh

# Install slack client
#sudo snap install --classic slack

mkdir -p ~/.ssh
git config --global user.email "neal@crunchbase.com"
git config --global user.name "Neal Hardesty"
git config --global core.fileMode false
git config pull.rebase true
ssh-keyscan github.com > ~/.ssh/known_hosts

# Docker time
source $(dirname $0)/install-ubuntu-docker.sh

# Don't need no fancy login manager
#sudo systemctl set-default multi-user.target


