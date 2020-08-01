#!/usr/bin/env bash

wget -O - https://raw.githubusercontent.com/laurent22/joplin/master/Joplin_install_and_update.sh | bash -x
sudo cp ~/.joplin/Joplin.AppImage /usr/local/bin/joplin
