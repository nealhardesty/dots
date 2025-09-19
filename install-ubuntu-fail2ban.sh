#!/bin/bash

# Script to install and configure Fail2ban on Ubuntu 24.04 
# with SSH protection on both port 22 and port 2222

set -e

echo "Updating system packages..."
sudo apt update
sudo apt upgrade -y

echo "Installing Fail2ban..."
sudo apt install -y fail2ban

echo "Backing up default jail.conf configuration..."
if [ ! -f /etc/fail2ban/jail.local ]; then
    sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
fi

echo "Configuring Fail2ban for SSH on ports 22 and 2222..."
sudo bash -c 'cat << EOF > /etc/fail2ban/jail.local
[DEFAULT]
# Ban time: 4 hours
bantime = 14400
# Number of retries allowed
maxretry = 3
# Time window for counting retries (in seconds)
findtime = 600

[sshd-22]
enabled = true
port = 22
filter = sshd
logpath = /var/log/auth.log

[sshd-2222]
enabled = true
port = 2222
filter = sshd
logpath = /var/log/auth.log
EOF'

echo "Restarting Fail2ban service..."
sudo systemctl restart fail2ban

echo "Enabling Fail2ban to start on boot..."
sudo systemctl enable fail2ban

echo "Fail2ban installation and SSH protection on ports 22 and 2222 setup complete."
echo "You can check Fail2ban status with: sudo systemctl status fail2ban"
echo "You can view Fail2ban SSH jail status with: sudo fail2ban-client status sshd-22"

