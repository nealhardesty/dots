#!/bin/bash -x

sudo apt remove -y firefox
sudo apt install -y curl

curl -L -o /var/tmp/firefox.tar.bz2 'https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US'
cd /opt
bzip2 -dc /var/tmp/firefox.tar.bz2 | sudo tar xvf - -C /opt
sudo ln -s /opt/firefox/firefox /usr/local/bin/firefox
