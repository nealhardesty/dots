#!/bin/bash

# Exit immediately if any command fails
set -e

echo "=== Starting Complete VMware Workstation Installation ==="

# 1. Install prerequisites (CachyOS headers, git, and build tools)
echo "--> Installing kernel headers and compilation tools..."
sudo pacman -S --needed --noconfirm linux-cachyos-headers git base-devel

# 2. Clone, build, and install VMware Workstation from the AUR
echo "--> Downloading and building VMware Workstation..."
cd /tmp
# Clean up any leftover directory from previous attempts
rm -rf vmware-workstation
git clone https://aur.archlinux.org/vmware-workstation.git
cd vmware-workstation
makepkg -si --noconfirm
cd ..
rm -rf vmware-workstation

# 3. Configure and enable background system services
echo "--> Configuring systemd services..."
# Generate the initial default network configurations
sudo systemctl start vmware-networks-configuration.service

# Enable services to run automatically on system boot, and start them now
sudo systemctl enable --now vmware-networks.service
sudo systemctl enable --now vmware-usbarbitrator.service

# 4. Make kernel modules persistent across reboots
echo "--> Configuring automatic kernel module loading on boot..."
sudo mkdir -p /etc/modules-load.d
echo -e "vmw_vmci\nvmmon" | sudo tee /etc/modules-load.d/vmware.conf > /dev/null

# 5. Load modules for the current session immediately
echo "--> Loading kernel modules for the active session..."
sudo modprobe -a vmw_vmci vmmon

echo "=== VMware Workstation Installation Complete! ==="
echo "The system is fully configured, modules are loaded, and they will persist on reboot."
