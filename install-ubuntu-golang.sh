#!/usr/bin/env bash

VERSION=1.21.0

DOWNLOAD=https://go.dev/dl/go${VERSION}.linux-amd64.tar.gz

curl -sL ${DOWNLOAD} |sudo tar -C /usr/local -xzvf -
