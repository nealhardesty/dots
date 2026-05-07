#!/bin/bash

# 1. Add the Warp repository to pacman.conf
sudo sh -c "echo -e '\n[warpdotdev]\nServer = https://releases.warp.dev/linux/pacman/\$repo/\$arch' >> /etc/pacman.conf"

# 2. Import the GPG signing key
sudo pacman-key -r "linux-maintainers@warp.dev"
sudo pacman-key --lsign-key "linux-maintainers@warp.dev"

# 3. Synchronize repositories and install Warp
sudo pacman -Sy warp-terminal


# Alternately
# paru -S warp-terminal-bin
