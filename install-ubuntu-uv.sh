#!/bin/bash
set -ex

sudo apt install -y curl

curl -LsSf https://astral.sh/uv/install.sh | sh

sudo cp -v ~/.local/bin/uv* /usr/local/bin/

uv --version
