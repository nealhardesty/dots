#!/bin/bash

set -ex

# Install LXD snap package
sudo snap install lxd

# Add current user to lxd group
sudo usermod -aG lxd "$USER"

echo "User $USER added to lxd group. Please log out and log back in for this to take effect."

# Detect first non-loopback network interface (for info)
FIRST_IFACE=$(ip -o link show | awk -F': ' '{print $2}' | grep -v lo | head -n 1)
echo "Detected first non-loopback network interface: $FIRST_IFACE"

# Generate a strong 24-character random base64 password
if ! command -v openssl >/dev/null 2>&1; then
  echo "openssl not found. Installing..."
  sudo apt update && sudo apt install -y openssl
fi
TRUST_PASSWORD=$(openssl rand -base64 18)
echo "Generated random trust password."

# Run lxd init with preseed configuration
sudo lxd init --preseed <<EOF
config:
  core.https_address: '[::]:8443'
  core.trust_password: "$TRUST_PASSWORD"

networks:
- name: lxdbr0
  type: bridge
  config:
    ipv4.address: 192.168.77.1/24
    ipv4.dhcp: "false"
    ipv4.nat: "true"
    ipv6.address: none

storage_pools:
- name: default
  driver: dir
  config: {}

profiles:
- name: default
  devices:
    eth0:
      name: eth0
      network: lxdbr0
      type: nic
    root:
      path: /
      pool: default
      type: disk

cluster: null
EOF

echo "LXD initialization complete."
echo "Use the following trust password to add clients if needed:"
echo "$TRUST_PASSWORD"

echo "To change the trust password later, run:"
echo "sudo lxc config set core.trust_password '$TRUST_PASSWORD'"
echo "or:"
echo "sudo lxc config unset core.trust_password"


echo
echo "Remember to log out and back in to apply the group membership for LXD commands without sudo."

# Wait for LXD to be ready
echo
echo "Waiting for LXD to be ready..."
sudo lxd waitready

# Create a profile for containers with home and Windows mount
echo "Creating profile with home and Windows mounts..."
lxc profile create dev-profile

# Configure the dev-profile with network, storage, and mounts
lxc profile device add dev-profile eth0 nic nictype=bridged parent=lxdbr0
lxc profile device add dev-profile root disk path=/ pool=default
lxc profile device add dev-profile home disk source=/home path=/mnt/home

# Add Windows drive mounts for any detected WSL mounts
echo "Scanning for WSL drive mounts in /mnt/..."
WSL_MOUNTS_FOUND=false
for mount_point in /mnt/*; do
    if [ -d "$mount_point" ] && [ "$(basename "$mount_point")" != "wsl" ] && [ "$(basename "$mount_point")" != "wslg" ]; then
        drive_letter=$(basename "$mount_point")
        echo "Found $mount_point - adding Windows $drive_letter: drive mount..."
        lxc profile device add dev-profile "mnt-$drive_letter" disk source="$mount_point" path="$mount_point"
        WSL_MOUNTS_FOUND=true
    fi
done

if [ "$WSL_MOUNTS_FOUND" = false ]; then
    echo "No WSL drive mounts found in /mnt/"
fi

# Add home directory mount
CURRENT_USER=$(whoami)
HOME_DIR="/home/$CURRENT_USER"
echo "Adding home directory mount: $HOME_DIR -> /mnt/$CURRENT_USER"
lxc profile device add dev-profile "mnt-$CURRENT_USER" disk source="$HOME_DIR" path="/mnt/$CURRENT_USER" 

# Set some sensible defaults for development
lxc profile set dev-profile security.nesting true
lxc profile set dev-profile security.privileged false

# Create default Ubuntu 22.04 container
echo "Creating default Ubuntu 22.04 container 'ubuntu-dev'..."
lxc launch ubuntu:22.04 ubuntu-dev --profile dev-profile

# Wait for container to be ready and configure permanent static IP
echo "Configuring container network..."
sleep 5

# Create permanent network configuration using netplan
lxc exec ubuntu-dev -- bash -c 'cat > /etc/netplan/10-lxc.yaml << EOF
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: false
      addresses:
        - 192.168.77.10/24
      routes:
        - to: default
          via: 192.168.77.1
      nameservers:
        addresses:
          - 1.1.1.1
          - 1.0.0.1
EOF'

# Set proper permissions for netplan config file (600 = rw for owner only)
lxc exec ubuntu-dev -- chmod 600 /etc/netplan/10-lxc.yaml

# Apply the netplan configuration
lxc exec ubuntu-dev -- netplan apply

# Configure DNS to use Cloudflare (1.1.1.1)
echo "Configuring DNS to use 1.1.1.1..."
lxc exec ubuntu-dev -- bash -c 'echo "nameserver 1.1.1.1" > /etc/resolv.conf'

# Update the container
echo "Updating container packages..."
lxc exec ubuntu-dev -- apt update
lxc exec ubuntu-dev -- apt upgrade -y

# Install some useful packages
echo "Installing useful packages..."
lxc exec ubuntu-dev -- apt remove -y nano
lxc exec ubuntu-dev -- bash -c 'DEBIAN_FRONTEND=noninteractive apt install -y -qq zsh curl wget git vim htop build-essential tmux rsync net-tools dnsutils nmap nmon autossh'

# Create user with current username, specific UID, zsh shell, and no password
CURRENT_USER=$(whoami)
echo "Creating user '$CURRENT_USER' with UID 1026..."
lxc exec ubuntu-dev -- useradd -u 1026 -s /bin/zsh -m "$CURRENT_USER"
lxc exec ubuntu-dev -- passwd -d "$CURRENT_USER"

# Add current user to sudoers with no password required
echo "Adding $CURRENT_USER to sudoers with no password..."
lxc exec ubuntu-dev -- bash -c "echo \"$CURRENT_USER ALL=(ALL) NOPASSWD:ALL\" >> /etc/sudoers.d/$CURRENT_USER"
lxc exec ubuntu-dev -- chmod 440 "/etc/sudoers.d/$CURRENT_USER"

# Ensure mount points exist and have proper permissions inside container
echo "Setting up mount points inside container..."
lxc exec ubuntu-dev -- mkdir -p /mnt
for mount_point in /mnt/*; do
    if [ -d "$mount_point" ] && [ "$(basename "$mount_point")" != "wsl" ] && [ "$(basename "$mount_point")" != "wslg" ]; then
        drive_letter=$(basename "$mount_point")
        echo "Setting up /mnt/$drive_letter in container..."
        lxc exec ubuntu-dev -- mkdir -p "/mnt/$drive_letter"
        
        # Add to /etc/fstab for persistence across container reboots
        echo "Adding /mnt/$drive_letter to /etc/fstab in container..."
        lxc exec ubuntu-dev -- bash -c "echo '$mount_point /mnt/$drive_letter none bind,defaults 0 0' >> /etc/fstab"
    fi
done

# Set up home directory mount point in container
echo "Setting up home directory mount in container..."
lxc exec ubuntu-dev -- mkdir -p "/mnt/$CURRENT_USER"

# Add home directory to /etc/fstab for persistence
echo "Adding home directory to /etc/fstab in container..."
lxc exec ubuntu-dev -- bash -c "echo '$HOME_DIR /mnt/$CURRENT_USER none bind,defaults 0 0' >> /etc/fstab"

lxc exec ubuntu-dev -- bash -c 'echo "nameserver 1.1.1.1" > /etc/resolv.conf'

echo
echo "=== LXD Setup Complete ==="
echo "Default container 'ubuntu-dev' created with:"
echo "  - IP: 192.168.77.10"
echo "  - /home mounted from host"

# Show which WSL drives were mounted
for mount_point in /mnt/*; do
    if [ -d "$mount_point" ] && [ "$(basename "$mount_point")" != "wsl" ] && [ "$(basename "$mount_point")" != "wslg" ]; then
        drive_letter=$(basename "$mount_point")
        echo "  - $mount_point mounted from host (Windows $drive_letter: drive)"
    fi
done

echo "  - Basic development tools installed"
echo
echo "To access the container:"
echo "  lxc exec ubuntu-dev -- bash"
echo
echo "To list all containers:"
echo "  lxc list"
