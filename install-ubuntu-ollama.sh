#!/bin/sh

# https://ollama.com/download/linux

curl -fsSL https://ollama.com/install.sh | sudo sh

echo https://ollama.com/library/llama3.1
ollama pull llama3.1
# ollama run llama3.1:405b


echo https://ollama.com/library/codellama
ollama pull codellama
# ollama pull codellama:34b
