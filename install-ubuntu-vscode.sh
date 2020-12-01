#!/bin/bash

#cd ~/Downloads

#curl -L -o vscode.deb https://go.microsoft.com/fwlink/?LinkID=760868

#sudo dpkg -i vscode.deb
#sudo apt --fix-broken -y install

#which snap || echo "Please install 'snapd'" && exit 1

#sudo snap install --classic code
#sudo ln -s /snap/bin/code /usr/local/code

sudo apt-get install -y apt-transport-https

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg

sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/

echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" |sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt-get update
sudo apt-get install code # or code-insiders

code --install-extension --force vscodevim.vim
#code --install-extension --force ms-python.python
#code --install-extension --force ms-vscode.Go

