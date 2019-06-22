#!/bin/bash

cd ~/Downloads

curl -L -o vscode.deb https://go.microsoft.com/fwlink/?LinkID=760868

sudo dpkg -i vscode.deb
sudo apt --fix-broken -y install
