#!/usr/bin/env bash
set -e

sudo apt update
sudo apt install -y software-properties-common fuse3

sudo add-apt-repository -y ppa:sebastian-stenzel/cryptomator
sudo apt update
sudo apt install -y cryptomator
