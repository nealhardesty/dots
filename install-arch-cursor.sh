#!/bin/bash

set -ex

sudo pacman -S --needed git base-devel --noconfirm

paru -S cursor-bin --noconfirm

curl https://cursor.com/install -fsS | bash


echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/bashrc.local
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/zshrc.local

echo "Finished. Run 'source ~/.bashrc' or 'source ~/.zshrc' to apply PATH changes."
echo "Then run 'cursor-agent --version' to check."
