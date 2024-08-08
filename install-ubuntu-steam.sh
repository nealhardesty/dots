#!/bin/sh
#

set -ex

sudo dpkg --add-architecture i386
sudo apt update
sudo apt upgrade -y

sudo apt install -y steam-installer

/usr/games/steam
