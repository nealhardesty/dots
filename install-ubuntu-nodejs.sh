#!/bin/bash

set -e

VERSION=$(curl -s https://nodejs.org/dist/index.json | grep -o '"version":"[^"]*"' | head -1 | cut -d'"' -f4 | sed 's/^v//')

sudo apt install -y yarn sudo curl

echo Installing Nodejs ${VERSION}
cd /var/tmp
wget https://nodejs.org/dist/v${VERSION}/node-v${VERSION}-linux-x64.tar.xz
xz -dc node*.tar.xz | sudo tar xvfC - /opt
sudo ln -svf /opt/node-v* /opt/node

[ -e ~/.bashrc.local ] && echo 'export PATH=/opt/node/bin:$PATH' >> ~/.bashrc.local
[ -e ~/.zshrc.local ] && echo 'export PATH=/opt/node/bin:$PATH' >> ~/.zshrc.local

export PATH=/opt/node/bin:$PATH

curl -qL https://www.npmjs.com/install.sh | sh

npm install -g npm@latest

npm install -g yarn@latest



