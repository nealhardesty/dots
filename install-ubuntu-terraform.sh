#!/bin/bash

version=0.14.3
release=https://releases.hashicorp.com/terraform/${version}/terraform_${version}_linux_amd64.zip

sudo apt install -y unzip

curl -sLo /var/tmp/t.zip "${release}" 
sudo unzip /var/tmp/t.zip -d /usr/local/bin/
rm /var/tmp/t.zip

