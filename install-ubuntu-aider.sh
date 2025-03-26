#!/bin/sh

python3 -m pip install aider-install
export PATH=${PATH}:${HOME}/.local/bin
aider-install
