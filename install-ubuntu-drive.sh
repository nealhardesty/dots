#!/bin/bash

./install-ubuntu-golang.sh

go get -u github.com/odeke-em/drive/cmd/drive
sudo cp $GOPATH/bin/drive /usr/local/bin/drive

mkdir ~/Drive
cd ~/Drive
drive init
drive pull
