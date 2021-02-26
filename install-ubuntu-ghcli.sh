#!/bin/bash


set -ex

#RELEASE=https://github.com/cli/cli/releases/download/v0.11.1/gh_0.11.1_linux_amd64.deb
RELEASE="https://github.com/cli/cli/releases/download/v1.6.2/gh_1.6.2_linux_amd64.deb"

echo "Installing github CLI from ${RELEASE}"

curl -Lso /var/tmp/gh.deb "${RELEASE}" 

sudo dpkg -i /var/tmp/gh.deb

rm /var/tmp/gh.deb
