#!/bin/sh

#sudo apt install --install-recommends wine64 winbind winetricks

sudo dpkg --add-architecture i386

cd /tmp

wget -nc https://dl.winehq.org/wine-builds/winehq.key
sudo apt-key add winehq.key

sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main'

sudo apt update -y
sudo apt install -y --install-recommends winehq-stable winbind winetricks

