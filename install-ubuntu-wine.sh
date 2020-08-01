#!/bin/sh

# https://linuxconfig.org/how-to-install-battle-net-on-ubuntu-20-04-linux-desktop

#sudo apt install --install-recommends wine64 winbind winetricks

CODENAME=$(. /etc/os-release; echo $VERSION_CODENAME)
CODENAME=${CODENAME:-bionic}

sudo dpkg --add-architecture i386
sudo apt install -y wget sudo 

cd /tmp

wget -nc https://dl.winehq.org/wine-builds/winehq.key
sudo apt-key add winehq.key

sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ ${CODENAME} main'

sudo apt update -y
sudo apt install -y --install-recommends winehq-staging winbind winetricks

