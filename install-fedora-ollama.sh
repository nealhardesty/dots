#!/bin/sh

set -ex

curl -fsSL https://ollama.com/install.sh | sh

ollama pull llama3.2
ollama pull mistral
ollama pull codestral
