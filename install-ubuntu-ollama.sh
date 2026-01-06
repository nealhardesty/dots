#!/bin/bash

set -ex

# https://ollama.com/download/linux

curl -fsSL https://ollama.com/install.sh | sudo sh

sudo mkdir -p /etc/systemd/system/ollama.service.d 
printf "[Service]\nEnvironment=\"OLLAMA_HOST=0.0.0.0\"\n" | sudo tee /etc/systemd/system/ollama.service.d/override.conf 
sudo systemctl daemon-reload 
sudo systemctl restart ollama

echo https://ollama.com/library/llama3.1
ollama pull llama3.1:8b
# ollama run llama3.1:405b

echo https://ollama.com/library/codellama
ollama pull codellama
# ollama pull codellama:34b

echo https://ollama.com/library/gpt-oss:20b
ollama pull gpt-oss

echo https://ollama.com/library/deepseek-r1
ollama pull deepseek-r1:8b

echo https://ollama.com/library/qwen2.5-coder
ollama pull qwen2.5-coder:7b
