#!/bin/bash

set -e

echo "Setting up Claude Code alias..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Node.js is not installed. Please install Node.js first."
    echo "You can run: ./install-ubuntu-nodejs.sh"
    exit 1
fi

# Create .bashrc.local and .zshrc.local if they don't exist
touch ~/.bashrc.local ~/.zshrc.local

# Add alias for claude-code using npx
if ! grep -q "claude=" ~/.bashrc.local 2>/dev/null; then
    echo 'alias claude="npx -y @anthropic-ai/claude-code"' >> ~/.bashrc.local
    echo '#alias claude="npx -y @anthropic-ai/claude-code --dangerously-skip-permissions"' >> ~/.bashrc.local
fi

if ! grep -q "claude=" ~/.zshrc.local 2>/dev/null; then
    echo 'alias claude="npx -y @anthropic-ai/claude-code"' >> ~/.zshrc.local
    echo '#alias claude="npx -y @anthropic-ai/claude-code --dangerously-skip-permissions"' >> ~/.zshrc.local
fi

# Source the local configs from main rc files if not already done
if ! grep -q ".bashrc.local" ~/.bashrc 2>/dev/null; then
    echo '[ -f ~/.bashrc.local ] && source ~/.bashrc.local' >> ~/.bashrc
fi

if ! grep -q ".zshrc.local" ~/.zshrc 2>/dev/null; then
    echo '[ -f ~/.zshrc.local ] && source ~/.zshrc.local' >> ~/.zshrc
fi

echo "Claude Code alias setup completed successfully!"
echo "Please restart your terminal or run 'source ~/.bashrc' (or ~/.zshrc) to use 'claude' command."
