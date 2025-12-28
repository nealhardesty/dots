#!/bin/bash

# https://docs.docker.com/engine/install/ubuntu/

set -ex

for pkg in docker.io docker-doc docker-compose podman-docker containerd runc
do 
  sudo apt-get remove -y $pkg
done

# Docker time
# Get Ubuntu codename (works for both Ubuntu and Linux Mint)
UBUNTU_CODENAME=$(grep UBUNTU_CODENAME /etc/os-release | cut -d= -f2 || lsb_release -cs)

# Remove any existing Docker repository entries
sudo rm -f /etc/apt/sources.list.d/docker*.list
for file in /etc/apt/sources.list.d/*.list; do
  if [ -f "$file" ]; then
    sudo sed -i '/download.docker.com\/linux\/ubuntu/d' "$file"
  fi
done

# Install GPG key using modern method (replaces deprecated apt-key)
sudo install -m 0755 -d /etc/apt/keyrings
sudo rm -f /etc/apt/keyrings/docker.gpg
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  ${UBUNTU_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker ${USER}

cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "bip": "10.42.0.1/24",
  "default-address-pools":[
    {"base":"10.43.0.0/16","size":24},
    {"base":"10.44.0.0/16","size":24}
  ]
}
EOF

sudo systemctl restart docker

#echo Installing docker-compose
#sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
#sudo chmod +x /usr/local/bin/docker-compose

echo
echo add this to /etc/docker/daemon.json to open external ports:
echo '"hosts": ["fd://","unix:///var/run/docker.sock","tcp://0.0.0.0:2376"]'
