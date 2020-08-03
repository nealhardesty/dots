#!/bin/bash

version=0.12.29
release=https://releases.hashicorp.com/terraform/${version}/terraform_${version}_linux_amd64.zip

curl -sLo /var/tmp/t.zip "${release}" 
sudo unzip /var/tmp/t.zip -d /usr/local/bin/
rm /var/tmp/t.zip

