#!/usr/bin/env bash
set -e

brew tap macos-fuse-t/homebrew-cask
brew install fuse-t curl jq

ARCH="$(uname -m)"

case "$ARCH" in
  arm64)  PATTERN='mac-arm64\.zip$' ;;
  x86_64) PATTERN='mac-x64\.zip$' ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

URL="$(
  curl -fsSL https://api.github.com/repos/cryptomator/cli/releases/latest |
  jq -r --arg re "$PATTERN" \
    '.assets[].browser_download_url | select(test($re))' |
  head -n1
)"

curl -fL "$URL" -o /tmp/cryptomator-cli.zip

sudo rm -rf /Applications/cryptomator-cli.app
unzip -q /tmp/cryptomator-cli.zip -d /tmp/cryptomator-cli
sudo mv /tmp/cryptomator-cli/cryptomator-cli.app /Applications/

sudo ln -sf \
  /Applications/cryptomator-cli.app/Contents/MacOS/cryptomator-cli \
  /usr/local/bin/cryptomator-cli

rm -rf /tmp/cryptomator-cli*

cryptomator-cli --version
