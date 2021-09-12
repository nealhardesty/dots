#!/bin/bash

set -ex

sudo apt install -y wget

cd /tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
rm /tmp/google-chrome-stable_current_amd64.deb


