#!/bin/bash


set -ex

RELEASE="https://github.com/cli/cli/releases/download/v2.7.0/gh_2.7.0_macOS_amd64.tar.gz"

echo "Installing github CLI from ${RELEASE}"

curl -Ls "${RELEASE}"  | sudo tar --strip 1 --exclude LICENSE -xzvf - -C /usr/local
