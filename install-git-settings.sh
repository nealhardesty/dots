#!/bin/bash

mkdir -p ~/.ssh

git config --global user.email "neal@crunchbase.com"
git config --global user.name "Neal Hardesty"
git config --global core.fileMode false

git config pull.rebase false

ssh-keyscan github.com >> ~/.ssh/known_hosts
