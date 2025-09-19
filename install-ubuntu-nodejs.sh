#!/bin/bash

set -e

echo "Installing nvm (Node Version Manager)"

# Get the latest nvm version
NVM_VERSION=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep '"tag_name"' | sed 's/.*"tag_name": *"\([^"]*\)".*/\1/')

echo "Installing nvm version: $NVM_VERSION"

# Install nvm using the recommended method
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash

# Source nvm for current session
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Ensure nvm is configured for both bash and zsh
echo "Configuring nvm for bash and zsh shells"

# Add to .bashrc.local if it exists and doesn't already contain nvm
if [ -f ~/.bashrc.local ] && ! grep -q "NVM_DIR" ~/.bashrc.local; then
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc.local
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc.local
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc.local
fi

# Add to .zshrc.local if it exists and doesn't already contain nvm
if [ -f ~/.zshrc.local ] && ! grep -q "NVM_DIR" ~/.zshrc.local; then
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc.local
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc.local
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.zshrc.local
fi

echo "Installing Node.js LTS"
# Install and use the latest LTS version
nvm install --lts
nvm use --lts
nvm alias default lts/*

echo "Verifying installation"
echo "Node.js version: $(node --version)"
echo "npm version: $(npm --version)"
echo "Node.js installed at: $(which node)"
echo "nvm current version: $(nvm current)"

echo "Installing global packages"
npm install -g npm@latest
npm install -g yarn@latest

echo "Creating symlinks in ~/bin"
# Create ~/bin directory if it doesn't exist
mkdir -p ~/bin

# Get the current Node.js version path
NODE_VERSION=$(nvm current)
NODE_PATH="$HOME/.nvm/versions/node/$NODE_VERSION"

# Create symlinks for easy access
ln -sf "$NODE_PATH/bin/node" ~/bin/node
ln -sf "$NODE_PATH/bin/npm" ~/bin/npm
ln -sf "$NODE_PATH/bin/npx" ~/bin/npx
ln -sf "$NODE_PATH/bin/yarn" ~/bin/yarn
ln -sf "$HOME/.nvm/nvm.sh" ~/bin/nvm

echo "Installation complete!"
echo "Node.js, npm, npx, yarn, and nvm are now available in ~/bin"
echo "Note: You may need to restart your terminal or run 'source ~/.bashrc.local' (bash) or 'source ~/.zshrc.local' (zsh) to use node/npm in new shells"



