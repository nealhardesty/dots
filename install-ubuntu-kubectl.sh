#!/bin/bash


#sudo curl -o /usr/local/bin/kubectl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
#sudo chmod 755 /usr/local/bin/kubectl

. /etc/lsb-release
[ ! -z "$DISTRIB_CODENAME" ] || exit 1
echo Installing for DISTRIB_CODENAME=$DISTRIB_CODENAME

sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubectl
sudo apt-mark hold kubectl


#sudo curl -Lo /usr/local/bin/kind https://github.com/kubernetes-sigs/kind/releases/download/v0.8.1/kind-linux-amd64 && sudo chmod a+x /usr/local/bin/kind
