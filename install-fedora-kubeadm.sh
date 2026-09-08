#!/bin/sh

# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
#

set -ex


# check 6443 is open
nc 127.0.0.1 6443 -v && exit 1
