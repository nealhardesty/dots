#!/bin/bash

# https://docs.docker.com/engine/install/ubuntu/

set -ex

for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc
do 
  sudo apt-get remove -y $pkg
done

# Docker time
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository -y \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"

sudo apt-get install -y docker-ce
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

echo Installing docker-compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo
echo add this to /etc/docker/daemon.json to open external ports:
echo '"hosts": ["fd://","unix:///var/run/docker.sock","tcp://0.0.0.0:2376"]'
