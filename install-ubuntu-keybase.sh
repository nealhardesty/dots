#!/bin/sh
cd /tmp
curl --remote-name https://prerelease.keybase.io/keybase_amd64.deb
sudo apt install ./keybase_amd64.deb
rm ./keybase_amd64.deb
run_keybase
