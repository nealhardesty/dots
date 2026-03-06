#!/bin/sh
#

set -x

cd /var/tmp

sudo apt update && sudo apt install -y zstd

curl -fsSL https://ollama.com/download/ollama-linux-amd64.tar.zst -o ollama.tar.zst

sudo tar --zstd -xvf ollama.tar.zst -C /usr/local

echo Add to shell startup:
echo export OLLAMA_HOST=XXX.XXX.XXX.XXX:11434
