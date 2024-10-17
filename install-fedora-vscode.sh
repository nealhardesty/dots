#!/bin/bash

set -ex

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

dnf check-update
sudo dnf install -y code # or code-insiders

code --install-extension --force vscodevim.vim
#code --install-extension --force ms-python.python
#code --install-extension --force ms-vscode.Go

