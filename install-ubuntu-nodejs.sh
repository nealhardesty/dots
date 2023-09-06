#!/bin/bash

set -e

VERSION=18.17.1

sudo apt install -y yarn sudo curl

echo Installing Nodejs ${VERSION}
cd /var/tmp
wget https://nodejs.org/dist/v${VERSION}/node-v${VERSION}-linux-x64.tar.xz
xz -dc node*.tar.xz | sudo tar xvfC - /opt
sudo ln -svf /opt/node-v* /opt/node

echo Installing Yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt update -y
sudo apt install -y yarn

[ -e ~/.bashrc.local ] && echo 'export PATH=/opt/node/bin:$PATH' >> ~/.bashrc.local
[ -e ~/.zshrc.local ] && echo 'export PATH=/opt/node/bin:$PATH' >> ~/.zshrc.local

