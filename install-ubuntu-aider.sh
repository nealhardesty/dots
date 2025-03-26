#!/bin/sh

set -x

python3 -m pip install aider-install
export PATH=${PATH}:${HOME}/.local/bin
aider-install


ollama run qwen2.5-coder:14b ""
