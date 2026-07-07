#!/bin/bash
set -ex
cd /var/tmp
wget https://github.com/derailed/k9s/releases/latest/download/k9s_linux_amd64.deb
sudo apt install -y ./k9s_linux_amd64.deb
rm k9s_linux_amd64.deb
