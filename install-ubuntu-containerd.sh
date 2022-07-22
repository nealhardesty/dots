#!/bin/bash


. /etc/lsb-release
[ ! -z "$DISTRIB_CODENAME" ] || exit 1
echo Installing for DISTRIB_CODENAME=$DISTRIB_CODENAME

sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
echo Removing docker if present
sudo apt-get remove docker docker-engine docker.io containerd runc

sudo apt-get install -y kubelet kubeadm kubectl containerd
sudo apt-mark hold kubelet kubeadm kubectl containerd

sudo curl -o /usr/local/lib/systemd/system/containerd.service https://github.com/containerd/containerd/blob/main/containerd.service
sudo systemctl daemon-reload
sudo systemctl enable --now containerd

#sudo curl -Lo /usr/local/bin/kind https://github.com/kubernetes-sigs/kind/releases/download/v0.8.1/kind-linux-amd64 && sudo chmod a+x /usr/local/bin/kind
