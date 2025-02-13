#!/bin/bash

# https://docs.docker.com/engine/install/debian/

set -ex

sudo apt-get update
sudo apt-get install ca-certificates curl

echo "docker.io docker-doc docker-compose podman-docker containerd runc"| xargs sudo apt-get remove -y 
#for pkg in docker.io docker-doc docker-compose podman-docker containerd runc
#do 
#  sudo apt-get remove -y $pkg
#done

# Add Docker's official GPG key:
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo " ${DEBIAN_CODENAME:-${VERSION_CODENAME}}") stable" | sudo tee /etc/apt/sources.list.d/docker.list 
sudo apt-get update

sudo apt-get install -y docker-ce
sudo usermod -aG docker ${USER}
#
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
echo
echo add this to /etc/docker/daemon.json to open external ports:
echo '"hosts": ["fd://","unix:///var/run/docker.sock","tcp://0.0.0.0:2376"]'
