#!/bin/bash

# Check that script is NOT run as root (we use sudo inside)
if [ "$EUID" -eq 0 ]; then
  echo "Please run this as your normal user (do not use sudo ./script.sh)."
  exit 1
fi

echo "Installing prerequisites..."
sudo apt update && sudo apt install -y curl

echo "Adding Official Moonlight Repository..."
curl -1sLf 'https://dl.cloudsmith.io/public/moonlight-game-streaming/moonlight-qt/setup.deb.sh' | sudo -E bash

echo "Installing Moonlight Client..."
sudo apt update
sudo apt install -y moonlight-qt

echo "------------------------------------------------"
echo "Installation Done."
echo "Launch via 'moonlight' in your terminal or App Menu."
echo "------------------------------------------------"
