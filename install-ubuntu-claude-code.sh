#!/bin/bash

set -e

echo "Installing Claude Code..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Node.js is not installed. Please install Node.js first."
    echo "You can run: ./install-ubuntu-nodejs.sh"
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "npm is not installed. Please install npm first."
    echo "You can run: ./install-ubuntu-nodejs.sh"
    exit 1
fi

echo "Node.js version: $(node --version)"
echo "npm version: $(npm --version)"

# Install Claude Code globally
echo "Installing Claude Code..."
npm install -g @anthropic-ai/claude-code

echo "Claude Code installation completed successfully!"
echo "You can now use 'claude-code' command to start Claude Code."
