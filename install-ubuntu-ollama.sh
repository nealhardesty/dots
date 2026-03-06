#!/bin/bash

set -ex

# https://ollama.com/download/linux

curl -fsSL https://ollama.com/install.sh | sudo sh

sudo mkdir -p /etc/systemd/system/ollama.service.d 
printf "[Service]\nEnvironment=\"OLLAMA_HOST=0.0.0.0\"\n" | sudo tee /etc/systemd/system/ollama.service.d/override.conf 
sudo systemctl daemon-reload 
sudo systemctl restart ollama
