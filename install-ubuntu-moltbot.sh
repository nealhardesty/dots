#!/bin/bash

set -ex

# =============================================================================
# Moltbot Installation Script for WSL2 (Ubuntu)
# Based on: https://docs.molt.bot/platforms/windows
# =============================================================================

# -----------------------------------------------------------------------------
# Step 1: Enable systemd in WSL (required for gateway)
# -----------------------------------------------------------------------------
if ! grep -q "systemd=true" /etc/wsl.conf 2>/dev/null; then
    echo "Enabling systemd in WSL..."
    sudo tee /etc/wsl.conf >/dev/null <<'EOF'
[boot]
systemd=true
EOF
    echo ""
    echo "=============================================="
    echo "NOTE: WSL needs to be restarted for systemd to take effect."
    echo "Run 'wsl --shutdown' from PowerShell, then re-open Ubuntu and re-run this script."
    echo "=============================================="
    exit 0
fi

# -----------------------------------------------------------------------------
# Step 2: Verify systemd is running
# -----------------------------------------------------------------------------
if ! systemctl --user status >/dev/null 2>&1; then
    echo "ERROR: systemd is not running."
    echo "Please restart WSL with 'wsl --shutdown' from PowerShell, then re-open Ubuntu."
    exit 1
fi
echo "systemd is running."

# -----------------------------------------------------------------------------
# Step 3: Install Node.js and pnpm
# -----------------------------------------------------------------------------
. ./install-ubuntu-nodejs.sh

. ~/.bashrc.local

# Install pnpm
npm install -g pnpm

# -----------------------------------------------------------------------------
# Step 4: Clone and build Moltbot
# -----------------------------------------------------------------------------
MOLTBOT_DIR="$HOME/moltbot"

if [ ! -d "$MOLTBOT_DIR" ]; then
    echo "Cloning moltbot repository..."
    git clone https://github.com/moltbot/moltbot.git "$MOLTBOT_DIR"
else
    echo "Moltbot directory already exists at $MOLTBOT_DIR"
fi

cd "$MOLTBOT_DIR"

echo "Installing dependencies..."
pnpm install

echo "Building UI..."
pnpm ui:build

echo "Building moltbot..."
pnpm build

# -----------------------------------------------------------------------------
# Step 5: Onboard and install gateway service
# -----------------------------------------------------------------------------
echo "Running moltbot onboard with daemon installation..."
moltbot onboard --install-daemon

echo ""
echo "=============================================="
echo "Moltbot installation complete!"
echo "=============================================="
