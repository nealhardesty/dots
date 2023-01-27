#!/bin/sh
#https://gist.githubusercontent.com/davecoutts/5ccb403c3d90fcf9c8c4b1ea7616948d/raw/605149d55580beb2683cff6ae49a1c7d716bd800/unifi_ubuntu_2004.sh
sudo apt update
sudo apt install --yes apt-transport-https

echo 'deb https://www.ui.com/downloads/unifi/debian stable ubiquiti' | sudo tee /etc/apt/sources.list.d/100-ubnt-unifi.list
sudo wget -O /etc/apt/trusted.gpg.d/unifi-repo.gpg https://dl.ui.com/unifi/unifi-repo.gpg

sudo apt update
sudo apt install --yes openjdk-8-jre-headless unifi
sudo apt clean

sudo systemctl status --no-pager --full mongodb.service unifi.service
