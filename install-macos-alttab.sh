#!/usr/bin/env bash

cd /tmp
wget https://github.com/lwouis/alt-tab-macos/releases/download/v6.51.0/AltTab-6.51.0.zip

unzip AltTab*

sudo mv AltTab.app /Applications

rm AltTab*.zip

open /Applications/AltTab.app
