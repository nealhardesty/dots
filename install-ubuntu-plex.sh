#!/bin/sh
#


wget -q https://downloads.plex.tv/plex-keys/PlexSign.key -O - | sudo apt-key add -

echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/plexmediaserver.gpg] https://downloads.plex.tv/repo/deb/ public main' |sudo tee /etc/apt/sources.list.d/plexmediaserver.list

sudo apt update
sudo apt install -y plexmediaserver

sudo systemctl start plexmediaserver
