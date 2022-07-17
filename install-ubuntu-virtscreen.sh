#!/bin/sh

cd /tmp

sudo apt install -y curl

curl -Lo virtscreen.deb "https://github.com/kbumsik/VirtScreen/releases/download/0.3.1/virtscreen.deb"

sudo apt-get update
sudo apt-get install -y x11vnc
sudo dpkg -i virtscreen.deb
rm virtscreen.deb
