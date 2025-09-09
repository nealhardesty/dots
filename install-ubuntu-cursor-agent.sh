#!/bin/bash

set -e

echo "Installing Cursor Agent..."

# Install Cursor CLI
curl https://cursor.com/install -fsS | bash

# Add ~/.local/bin to PATH if not already present
if ! grep -q '$HOME/.local/bin' ~/.bashrc 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
fi

if ! grep -q '$HOME/.local/bin' ~/.zshrc 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
fi

echo "Cursor Agent installation completed successfully!"
echo "Please restart your terminal or run 'source ~/.bashrc' (or ~/.zshrc) to use cursor-agent command."
