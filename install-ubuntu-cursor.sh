#!/bin/bash

set -ex

sudo apt install -y wget

DOWNLOAD_URL="https://api2.cursor.sh/updates/download/golden/linux-x64-deb/cursor/2.1"
TEMP_DIR="/tmp"
DEB_FILENAME="cursor-latest.deb"
DEB_PATH="$TEMP_DIR/$DEB_FILENAME"

wget -O "$DEB_PATH" "$DOWNLOAD_URL"

sudo apt install -y "$DEB_PATH"
