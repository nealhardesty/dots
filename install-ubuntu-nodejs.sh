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
    echo '# Add Node.js global packages to PATH' >> ~/.bashrc.local
    echo 'export PATH="$(nvm which node | sed "s|/node$||")/bin:$PATH"' >> ~/.bashrc.local
fi

# Add to .zshrc.local if it exists and doesn't already contain nvm
if [ -f ~/.zshrc.local ] && ! grep -q "NVM_DIR" ~/.zshrc.local; then
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc.local
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc.local
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.zshrc.local
    echo '# Add Node.js global packages to PATH' >> ~/.zshrc.local
    echo 'export PATH="$(nvm which node | sed "s|/node$||")/bin:$PATH"' >> ~/.zshrc.local
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


echo "Installation complete!"
echo "Node.js, npm, npx, yarn, and globally installed packages are now available"
echo "Note: You may need to restart your terminal or run 'source ~/.bashrc.local' (bash) or 'source ~/.zshrc.local' (zsh) to use node/npm in new shells"



