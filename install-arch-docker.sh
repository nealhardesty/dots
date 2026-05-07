#!/usr/bin/env bash
set -euo pipefail

# Install Docker from official Arch repos
sudo pacman -S --needed --noconfirm docker docker-compose

# Add user to docker group
sudo usermod -aG docker "${USER}"

# Configure daemon with custom IP pools to avoid VPN conflicts
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "bip": "10.42.0.1/24",
  "default-address-pools":[
    {"base":"10.43.0.0/16","size":24},
    {"base":"10.44.0.0/16","size":24}
  ]
}
EOF

# Enable and start Docker
sudo systemctl enable --now docker

echo
echo "Log out and back in for group changes to take effect."
echo "Add this to /etc/docker/daemon.json to open external ports:"
echo '"hosts": ["fd://","unix:///var/run/docker.sock","tcp://0.0.0.0:2376"]'
