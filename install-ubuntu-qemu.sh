#!/bin/bash

set -ex

sudo apt update
sudo apt install -y qemu-kvm qemu-system-x86 libvirt-daemon-system libvirt-clients virt-manager dnsmasq ovmf swtpm sudo apt virtiofsd

# Enable and start libvirtd service
sudo systemctl enable --now libvirtd

# Add current user to libvirt group
sudo usermod -aG libvirt $USER

# Enable default network
sudo virsh net-autostart default
sudo virsh net-start default || true
