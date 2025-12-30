#!/bin/bash
set -ex

sudo apt update
sudo apt install -y curl wget

# Fetch the latest tag name (e.g., 1.4.4)
TAG=$(curl -s https://api.github.com/repos/rustdesk/rustdesk/releases/latest | grep "tag_name" | cut -d '"' -f 4)

# Remove 'v' prefix if present for the filename
VERSION=${TAG#v}

URL="https://github.com/rustdesk/rustdesk/releases/download/${TAG}/rustdesk-${VERSION}-x86_64.deb"
DEB_PATH="/tmp/rustdesk-${VERSION}.deb"

echo "Downloading RustDesk ${TAG} from ${URL}..."
wget -O "$DEB_PATH" "$URL"

echo "Installing RustDesk..."
sudo apt install -y "$DEB_PATH"

# Cleanup
rm "$DEB_PATH"
