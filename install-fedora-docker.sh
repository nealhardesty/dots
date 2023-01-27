#!/bin/sh
# https://docs.docker.com/engine/install/fedora/

sudo dnf -y install dnf-plugins-core
sudo dnf config-manager \
      --add-repo \
          https://download.docker.com/linux/fedora/docker-ce.repo

sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo usermod -G docker $(whoami)

sudo systemctl start docker

sudo docker run hello-world
