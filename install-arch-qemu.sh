#!/bin/sh

set -ex

sudo pacman -S --noconfirm qemu-full libvirt virt-manager dnsmasq iptables-nft edk2-ovmf swtpm

# Enable and start libvirtd service
sudo systemctl enable --now libvirtd

# Add current user to libvirt group
sudo usermod -aG libvirt $USER

# Enable default network
sudo virsh net-autostart default
sudo virsh net-start default || true

