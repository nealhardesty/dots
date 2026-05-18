#!/usr/bin/env bash

set -e

echo "Starting mas installation via GitHub releases..."

# 1. Determine system architecture
ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ]; then
    echo "Apple Silicon detected ($ARCH)"
else
    echo "Intel architecture detected ($ARCH)"
fi

# 2. Create a secure temporary directory for downloading
TMP_DIR=$(mktemp -d -t mas-install)
cd "$TMP_DIR"

echo "Fetching latest release asset metadata from GitHub..."

# 3. Target the specific .pkg distribution file for this architecture
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/mas-cli/mas/releases/latest \
  | grep "browser_download_url.*${ARCH}\.pkg" \
  | cut -d : -f 2,3 \
  | tr -d \" \
  | xargs)

if [ -z "$DOWNLOAD_URL" ]; then
    echo "Error: Could not find the mas .pkg download URL for architecture: $ARCH"
    exit 1
fi

echo "Downloading mas from: $DOWNLOAD_URL"
curl -L -O "$DOWNLOAD_URL"

# 4. Extract the exact file name from the download URL
PKG_NAME=$(basename "$DOWNLOAD_URL")

# 5. Install the package using the native macOS installer (requires sudo privileges)
echo "Installing package to system roots (you may be prompted for your password)..."
sudo installer -pkg "$PKG_NAME" -target /

# 6. Clean up temporary working directory
echo "Cleaning up temporary files..."
rm -rf "$TMP_DIR"

# 7. Verify the installation succeeded
echo "Installation complete!"
echo "Verifying version:"
/usr/local/bin/mas version
