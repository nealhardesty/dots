#!/bin/bash -x

sudo apt update
sudo apt remove -y nano
sudo apt install -y default-jdk build-essential python3 tmux git openssh-server vim samba cifs-utils wget curl jq net-tools dnsutils nmap htop nmon

setxkbmap -option caps:swapescape
