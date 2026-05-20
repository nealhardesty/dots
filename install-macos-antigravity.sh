#!/usr/bin/env bash

set -e

[ "$(uname -m)" = "arm64" ] || { echo "this script requires apple silicon (arm64)"; exit 1; }

DMG_URL="https://storage.googleapis.com/antigravity-public/antigravity-hub/2.0.0-6324554176528384/darwin-arm/Antigravity.dmg"
DMG_FILE="/tmp/Antigravity.dmg"
APP_NAME="Antigravity"
MOUNT_POINT="/Volumes/Antigravity"

# install GUI app
if [ -d "/Applications/${APP_NAME}.app" ]; then
    echo "${APP_NAME}.app already installed, skipping"
else
    echo "downloading ${APP_NAME}.dmg"
    curl -fsSL -o "$DMG_FILE" "$DMG_URL"
    xattr -rd com.apple.quarantine "$DMG_FILE" 2>/dev/null || true

    echo "mounting dmg"
    hdiutil attach "$DMG_FILE" -mountpoint "$MOUNT_POINT" -quiet

    echo "copying app to /Applications"
    ditto "${MOUNT_POINT}/${APP_NAME}.app" "/Applications/${APP_NAME}.app"

    echo "unmounting dmg"
    hdiutil detach "$MOUNT_POINT" -quiet

    rm -f "$DMG_FILE"
    echo "${APP_NAME}.app installed"
fi

# install CLI
if command -v antigravity &>/dev/null; then
    echo "antigravity cli already installed, skipping"
else
    echo "installing antigravity cli"
    curl -fsSL https://antigravity.google/cli/install.sh | bash
    echo "antigravity cli installed"
fi
