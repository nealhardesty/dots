#!/bin/bash

set -e

echo "Setting up Gemini CLI alias..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Node.js is not installed. Please install Node.js first."
    echo "You can run: ./install-ubuntu-nodejs.sh"
    exit 1
fi

# Create .bashrc.local and .zshrc.local if they don't exist
touch ~/.bashrc.local ~/.zshrc.local

# Add alias for gemini using npx
if ! grep -q "gemini=" ~/.bashrc.local 2>/dev/null; then
    echo 'alias gemini="npx -y @google/gemini-cli"' >> ~/.bashrc.local
fi

if ! grep -q "gemini=" ~/.zshrc.local 2>/dev/null; then
    echo 'alias gemini="npx -y @google/gemini-cli"' >> ~/.zshrc.local
fi

# Source the local configs from main rc files if not already done
if ! grep -q ".bashrc.local" ~/.bashrc 2>/dev/null; then
    echo '[ -f ~/.bashrc.local ] && source ~/.bashrc.local' >> ~/.bashrc
fi

if ! grep -q ".zshrc.local" ~/.zshrc 2>/dev/null; then
    echo '[ -f ~/.zshrc.local ] && source ~/.zshrc.local' >> ~/.zshrc
fi

echo "Gemini CLI alias setup completed successfully!"
echo "Please restart your terminal or run 'source ~/.bashrc' (or ~/.zshrc) to use 'gemini' command."
