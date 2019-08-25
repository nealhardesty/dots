#!/bin/bash

#cd ~/Downloads

#curl -L -o vscode.deb https://go.microsoft.com/fwlink/?LinkID=760868

#sudo dpkg -i vscode.deb
#sudo apt --fix-broken -y install

sudo snap install --classic vscode
/snap/bin/code --install-extension vscodevim.vim
/snap/bin/code --install-extension ms-python.python
/snap/bin/code --install-extension ms-vscode.Go
