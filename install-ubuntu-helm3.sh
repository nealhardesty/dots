#!/bin/bash

set -ex

VERSION="3.5.0"
sudo apt install -y curl
curl -o /tmp/helm.tgz https://get.helm.sh/helm-v${VERSION}-linux-amd64.tar.gz
mkdir /tmp/helm
tar xzvfC /tmp/helm.tgz /tmp/helm
sudo mv /tmp/helm/*/helm /usr/local/bin/helm3
chmod 755 /usr/local/bin/helm3
rm -r /tmp/helm
