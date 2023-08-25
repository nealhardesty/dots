#!/bin/sh

sudo apt update && sudo apt upgrade -y python3 python3-pip
python3 -m pip install --upgrade localstack

#https://docs.localstack.cloud/getting-started/installation/#docker
#docker run  --rm -it  -p 4566:4566  -p 4510-4559:4510-4559  localstack/localstack
