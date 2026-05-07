#!/usr/bin/env bash
set -euo pipefail

# Install Node.js/npm if missing
if ! command -v npm &>/dev/null; then
    sudo pacman -S --needed --noconfirm nodejs npm
fi

# Install Claude CLI
npm install -g @anthropic-ai/claude-code
