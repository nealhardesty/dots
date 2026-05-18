#!/usr/bin/env bash

set -e

XCODE_APP_ID="497799835"

# 1. Trigger the official Xcode download and installation directly
echo "Installing Xcode via Mac App Store CLI..."
echo "Note: This downloads a large archive and handles assembly in the background. Please wait."
/usr/local/bin/mas install "$XCODE_APP_ID"

# 2. Configure the active system developer directory path
echo "Configuring xcode-select developer paths..."
sudo mkdir -p /Applications/Xcode.app/Contents/Developer
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer

# 3. Automatically accept the license agreement
echo "Accepting Xcode license agreement..."
sudo xcodebuild -license accept

echo "Installation complete! Xcode is active and ready for use."
