#!/bin/bash

if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# Allow any key to unstick the terminal scroll lock
stty -ixany

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export KUBECONFIG=~/.kube/config:~/.kube/config-staging-eks
export PATH=/Users/neal/dev/ops_tools/bin:$PATH
