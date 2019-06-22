#!/bin/bash

sudo apt install -y yarn sudo curl

echo Installing Nodejs 10.15.0
cd /var/tmp
wget https://nodejs.org/dist/v10.15.0/node-v10.15.0-linux-x64.tar.xz
xz -dc node*.tar.xz | sudo tar xvfC - /opt
sudo ln -svf /opt/node-v* /opt/node

echo Installing Yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt update -y
sudo apt install -y yarn

echo 'export PATH=/opt/node/bin:$PATH' >> ~/.bashrc.local
