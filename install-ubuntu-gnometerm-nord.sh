#!/bin/bash

sudo apt install -y dconf-gsettings-backend dconf-cli dconf-service uuid-runtime

cd /tmp
git clone https://github.com/arcticicestudio/nord-gnome-terminal
cd nord-gnome-terminal/src
./nord.sh
