#!/bin/bash
set -ex

VERSION=1.8.2

mkdir /tmp/istioctl
curl -Lo /tmp/istioctl.tgz https://github.com/istio/istio/releases/download/${VERSION}/istioctl-${VERSION}-linux-amd64.tar.gz
tar xzvfC /tmp/istioctl.tgz /tmp/istioctl
sudo mv /tmp/istioctl/istioctl /usr/local/bin/istioctl
sudo chmod 755 /usr/local/bin/istioctl


