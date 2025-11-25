#!/bin/sh

set -ex

sudo pacman -S --noconfirm openssh fail2ban

# Disable SSH root login
sudo sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config

# Change SSH port to 2222
sudo sed -i 's/^#*Port.*/Port 2222/' /etc/ssh/sshd_config

sudo systemctl enable --now sshd
sudo ufw allow 2222/tcp

# Configure fail2ban for SSH
sudo tee /etc/fail2ban/jail.local > /dev/null <<EOF
[DEFAULT]
bantime = 1h
findtime = 10m
maxretry = 5
banaction = ufw

[sshd]
enabled = true
port = 2222
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
EOF

sudo systemctl enable --now fail2ban
