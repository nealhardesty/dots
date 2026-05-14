#!/bin/bash

# 1. Install Sunshine and Wayland tools
sudo pacman -S --noconfirm sunshine wayland-utils

# 2. Setup udev rules for input devices
echo 'KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess", GROUP="input", MODE="0660"' | sudo tee /etc/udev/rules.d/60-sunshine.rules
sudo udevadm control --reload-rules && sudo udevadm trigger

# 3. Add current user to input group
sudo usermod -aG input $USER

# 4. Set initial capabilities for KMS capture
sudo setcap cap_sys_admin+p $(readlink -f $(which sunshine))

# 5. Create Pacman Hook to persist capabilities across updates
sudo mkdir -p /etc/pacman.d/hooks
cat <<EOF | sudo tee /etc/pacman.d/hooks/sunshine.hook
[Trigger]
Operation = Install
Operation = Upgrade
Type = Package
Target = sunshine

[Action]
Description = Re-applying KMS capabilities to Sunshine...
When = PostTransaction
Exec = /usr/bin/setcap cap_sys_admin+p /usr/bin/sunshine
EOF

# Open UFW Ports
# TCP	47984, 47989, 48010
# UDP	47998, 47999, 48000, 48002, 48010
sudo ufw allow 47984/tcp
sudo ufw allow 47989/tcp
sudo ufw allow 48010/tcp
sudo ufw allow 47998/udp
sudo ufw allow 47999/udp
sudo ufw allow 48000/udp
sudo ufw allow 48002/udp
sudo ufw allow 48010/udp

# 6. Enable and start the Sunshine service
systemctl --user enable --now sunshine

# 7. Open configuration UI
xdg-open https://localhost:47990
