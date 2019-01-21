#!/bin/bash -x

echo  'neal    ALL=(ALL:ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/neal 
sudo chmod 0440 /etc/sudoers.d/neal

sudo apt update
# Kill it with fire
sudo apt remove -y nano
sudo apt install -y \
  openjdk-11-jdk \
  build-essential \
  python3 \
  python3-pip \
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
  software-properties-common 
  rxvt-unicode \
  autokey

sudo pip3 install --upgrade pip
sudo pip3 install awscli

setxkbmap -option caps:swapescape

git config --global user.email "neal@crunchbase.com"
git config --global user.name "Neal Hardesty"

# Docker time
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt update 
sudo apt-get install -y docker-ce
sudo usermod -G docker neal

# Don't need no fancy login manager
#sudo systemctl set-default multi-user.target


