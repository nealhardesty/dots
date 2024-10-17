#!/bin/bash

set -ex

sudo dnf install wget

cd /tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
sudo dnf install -y google-chrome-stable_current_x86_64.rpm
rm /tmp/google-chrome-stable_current_x86_64.rpm


