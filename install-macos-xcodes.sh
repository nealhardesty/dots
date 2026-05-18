#!/usr/bin/env bash

set -e

echo "Starting xcodes installation via GitHub releases..."

# 1. Determine system architecture
ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ]; then
    echo "Apple Silicon detected ($ARCH)"
else
    echo "Intel architecture detected ($ARCH)"
fi

# 2. Create a secure temporary directory for downloading
TMP_DIR=$(mktemp -d -t xcodes-install)
cd "$TMP_DIR"

echo "Fetching latest release asset metadata from GitHub..."

# 3. Target the correct xcodes.zip distribution archive
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/XcodesOrg/xcodes/releases/latest \
  | grep "browser_download_url.*xcodes\.zip" \
  | cut -d : -f 2,3 \
  | tr -d \" \
  | xargs)

if [ -z "$DOWNLOAD_URL" ]; then
    echo "Error: Could not find the xcodes.zip download URL."
    exit 1
fi

echo "Downloading xcodes from: $DOWNLOAD_URL"
curl -L -O "$DOWNLOAD_URL"

# 4. Unzip the downloaded file
echo "Extracting package..."
unzip -q xcodes.zip

# 5. Verify the binary exists in the extracted files
if [ ! -f "xcodes" ]; then
    echo "Error: 'xcodes' binary not found in the extracted archive."
    exit 1
fi

# 6. Install to /usr/local/bin (requires sudo privileges)
echo "Moving binary to /usr/local/bin (you may be prompted for your password)..."
sudo mkdir -p /usr/local/bin
sudo mv xcodes /usr/local/bin/
sudo chmod +x /usr/local/bin/xcodes

# 7. Strip the Gatekeeper quarantine attribute to prevent "unverified developer" popups
echo "Stripping macOS Gatekeeper quarantine flags..."
sudo xattr -d com.apple.quarantine /usr/local/bin/xcodes 2>/dev/null || true

# 8. Clean up temporary working directory
echo "Cleaning up temporary files..."
rm -rf "$TMP_DIR"

# 9. Verify the installation succeeded
echo "Installation complete!"
echo "Verifying version:"
/usr/local/bin/xcodes version
