#!/usr/bin/env bash

set -ex


# Better have already installed kubeadm....

# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/



which kubeadm || exit 1
which docker || exit 1


grep swap /etc/fstab && echo Warning... you have swap enabled...
sudo swapoff -a

sudo kubeadm init | tee ~/kubeadm.log

mkdir -p ~/.kube
sudo cp -v /etc/kubernetes/admin.conf ~/.kube/$(hostname)
sudo chown $(id -u):$(id -g) ~/.kube/$(hostname) 

echo ... export KUBECONFIG=~/.kube/$(hostname) ...
export KUBECONFIG=~/.kube/$(hostname)


# Calico CNI
#kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
#kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

kubectl taint nodes --all node-role.kubernetes.io/master-

echo export KUBECONFIG=$KUBECONFIG
