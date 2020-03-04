#!/bin/bash

#cd ~/Downloads

#curl -L -o vscode.deb https://go.microsoft.com/fwlink/?LinkID=760868

#sudo dpkg -i vscode.deb
#sudo apt --fix-broken -y install

sudo snap install --classic code
/snap/bin/code --install-extension --force vscodevim.vim
/snap/bin/code --install-extension --force ms-python.python
/snap/bin/code --install-extension --force ms-vscode.Go
#sudo ln -s /snap/bin/vscode /usr/local/bin/code
