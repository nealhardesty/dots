#!/usr/bin/env bash

set -ex


[ -x /usr/local/bin/kind ] || (sudo curl -Lo /usr/local/bin/kind https://github.com/kubernetes-sigs/kind/releases/download/v0.8.1/kind-linux-amd64 && sudo chmod a+x /usr/local/bin/kind)

[ -x /usr/local/bin/helm ] || curl -L https://get.helm.sh/helm-v2.16.9-linux-amd64.tar.gz | sudo tar --strip-components=1 -C /usr/local/bin -xzvf - linux-amd64/helm

export KUBECONFIG=${HOME}/.kube/config
export CLUSTER=${1:-kind}

# https://raw.githubusercontent.com/kubernetes-sigs/kind/master/site/content/docs/user/kind-example-config.yaml
# https://kind.sigs.k8s.io/docs/user/configuration/
# https://kind.sigs.k8s.io/docs/user/ingress 
cat > /var/tmp/kind-config.yaml <<EOF 
kind: Cluster 
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
  kubeadmConfigPatches:
  - |
    kind: JoinConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "foo-label=quux"
  extraMounts:
  - hostPath: ${HOME}
    containerPath: ${HOME}
- role: worker
  extraMounts:
  - hostPath: ${HOME}
    containerPath: ${HOME}
- role: worker
  extraMounts:
  - hostPath: ${HOME}
    containerPath: ${HOME}
EOF


kind create cluster --name ${CLUSTER} --config /var/tmp/kind-config.yaml

CONTEXT=kind-${CLUSTER}

kubectl config use-context ${CONTEXT}

kubectl --context=${CONTEXT} get ns 
kubectl --context=${CONTEXT} -n kube-system create serviceaccount tiller 
kubectl --context=${CONTEXT} create clusterrolebinding tiller --serviceaccount=kube-system:tiller --clusterrole=cluster-admin 
#helm --debug --kube-context=${CONTEXT} init --service-account tiller

helm --output yaml --kube-context=kind-kind init --service-account tiller | sed 's@apiVersion: extensions/v1beta1@apiVersion: apps/v1@' | kubectl patch --local -oyaml -f - -p '{"spec":{"selector": {"app":"helm","name":"tiller"}}}' |kubectl apply -f -


echo export KUBECONFIG=${KUBECONFIG}
