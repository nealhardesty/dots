#!/bin/bash

# Script to change Ubuntu SSH server port to 2222

set -e

SSHD_CONFIG="/etc/ssh/sshd_config"
NEW_PORT=2222

echo "Backing up current sshd configuration..."
sudo cp $SSHD_CONFIG "${SSHD_CONFIG}.bak.$(date +%F-%T)"

echo "Configuring sshd to listen on port $NEW_PORT..."

# Use sed to replace or add Port directive, preserving existing config
if grep -q "^#Port " $SSHD_CONFIG; then
  # Uncomment and change default Port line
  sudo sed -i "s/^#Port .*/Port $NEW_PORT/" $SSHD_CONFIG
elif grep -q "^Port " $SSHD_CONFIG; then
  # Change existing Port line
  sudo sed -i "s/^Port .*/Port $NEW_PORT/" $SSHD_CONFIG
else
  # No Port line found, add it
  echo "Port $NEW_PORT" | sudo tee -a $SSHD_CONFIG
fi

echo "Restarting sshd service to apply new port..."
sudo systemctl restart ssh

echo "sshd is now configured to run on port $NEW_PORT."
echo "Run 'sudo ss -tlnp | grep sshd' or 'sudo netstat -tlnp | grep sshd' to verify."
sudo ss -tlnp | grep sshd
echo "Remember to adjust firewall rules accordingly to allow port $NEW_PORT."

