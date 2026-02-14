#!/bin/bash

# Check that script is NOT run as root (needed for the auto-start config)
if [ "$EUID" -eq 0 ]; then
  echo "Please run this as your normal user (do not use sudo ./script.sh)."
  exit 1
fi

echo "Installing prerequisites..."
sudo apt update && sudo apt install -y curl wget

echo "Fetching latest Sunshine version for Ubuntu 24.04..."
# Grabs the latest .deb link from GitHub API
LATEST_URL=$(curl -s https://api.github.com/repos/LizardByte/Sunshine/releases/latest | grep "browser_download_url" | grep "ubuntu-24.04-amd64.deb" | cut -d '"' -f 4)

if [ -z "$LATEST_URL" ]; then
    echo "Error: Could not find the download link automatically. Please check your internet connection."
    exit 1
fi

echo "Downloading..."
wget -O sunshine.deb "$LATEST_URL"

echo "Installing Sunshine (enter sudo password if asked)..."
sudo apt install -y ./sunshine.deb

echo "Configuring Wayland permissions..."
# 1. Allow creating virtual input devices
echo 'KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"' | sudo tee /etc/udev/rules.d/60-sunshine.rules > /dev/null
sudo udevadm control --reload-rules
sudo udevadm trigger
sudo modprobe uinput

# 2. Add current user to input group
sudo usermod -aG input "$USER"

# 3. Allow screen capture without root
sudo setcap cap_sys_admin+p $(which sunshine)

echo "Enabling auto-start service..."
systemctl --user enable sunshine
systemctl --user start sunshine

# Cleanup
rm sunshine.deb

echo "------------------------------------------------"
echo "Installation Done."
echo "1. Open https://localhost:47990 in your browser to set up your PIN/Password."
echo "2. You MUST reboot for mouse/keyboard control to work."
echo "------------------------------------------------"

