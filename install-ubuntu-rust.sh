#!/bin/bash
set -ex

sudo apt update
sudo apt install -y curl git build-essential pkg-config libssl-dev

# Check if rust is installed
if ! command -v cargo &> /dev/null; then
    echo "🦀 Rust not found. Installing rustup..."
    curl https://sh.rustup.rs -sSf | sh -s -- -y
    echo '. "$HOME/.cargo/env"' >> ${HOME}/.zshrc.local
    source "$HOME/.cargo/env"

else
    echo "🦀 Rust is already installed."
fi

