#!/usr/bin/env bash

set -e

NVM_VERSION="v0.40.3"
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

# install nvm
if [ -s "$NVM_DIR/nvm.sh" ]; then
    echo "nvm already installed, skipping"
else
    echo "installing nvm ${NVM_VERSION}"
    # PROFILE=/dev/null stops the installer from editing ~/.zshrc and ~/.bashrc;
    # we add nvm to the .local files ourselves below
    PROFILE=/dev/null curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash
    echo "nvm installed"
fi

# add nvm to the shell rc.local files if present and not already configured
for rc in "$HOME/.zshrc.local" "$HOME/.bashrc.local"; do
    if [ -f "$rc" ] && ! grep -q "NVM_DIR" "$rc"; then
        echo "adding nvm to ${rc}"
        {
            echo 'export NVM_DIR="$HOME/.nvm"'
            echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"'
            echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"'
        } >> "$rc"
    fi
done

# load nvm into the current shell
# shellcheck disable=SC1090,SC1091
. "$NVM_DIR/nvm.sh"

# install the current LTS node and set it as default
echo "installing latest lts node"
nvm install --lts

echo "setting lts node as default"
nvm alias default 'lts/*'
nvm use default

echo "node $(node --version) is now the default"
echo "restart your terminal or source ~/.zshrc.local (or ~/.bashrc.local) to use node in new shells"
