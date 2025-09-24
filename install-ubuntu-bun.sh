#!/bin/bash

set -ex

curl -fsSL https://bun.sh/install | bash

echo 'export PATH="$HOME/.bun/bin:$PATH"' >> ~/.bashrc.local
echo 'export PATH="$HOME/.bun/bin:$PATH"' >> ~/.zshrc.local

source ~/.bashrc.local

bun --version