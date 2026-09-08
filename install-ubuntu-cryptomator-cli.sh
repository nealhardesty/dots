#!/usr/bin/env bash
set -e

sudo apt update
sudo apt install -y fuse3 curl unzip jq

ARCH="$(uname -m)"

case "$ARCH" in
    x86_64)  ARCH_PATTERN='linux.*x64.*zip' ;;
    aarch64|arm64) ARCH_PATTERN='linux.*arm64.*zip' ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

API="https://api.github.com/repos/cryptomator/cli/releases/latest"

URL="$(
    curl -fsSL "$API" |
    jq -r --arg re "$ARCH_PATTERN" \
      '.assets[].browser_download_url | select(test($re; "i"))' |
    head -n1
)"

if [ -z "$URL" ]; then
    echo "Could not find Cryptomator CLI release asset."
    exit 1
fi

curl -fL "$URL" -o /tmp/cryptomator-cli.zip

sudo rm -rf /opt/cryptomator-cli
sudo mkdir -p /opt/cryptomator-cli
sudo unzip -q /tmp/cryptomator-cli.zip -d /opt/cryptomator-cli

BIN="$(find /opt/cryptomator-cli -type f -name cryptomator-cli | head -n1)"
sudo chmod +x "$BIN"
sudo ln -sf "$BIN" /usr/local/bin/cryptomator-cli

rm /tmp/cryptomator-cli.zip

cryptomator-cli --version
