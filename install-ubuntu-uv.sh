#!/bin/bash
set -ex

sudo apt install -y curl

curl -LsSf https://astral.sh/uv/install.sh | sh

uv --version
