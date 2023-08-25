#!/bin/bash


# https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

 sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

 wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

 gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint

 echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update
sudo apt-get install terraform

#version=0.14.3
#release=https://releases.hashicorp.com/terraform/${version}/terraform_${version}_linux_amd64.zip
#
#sudo apt install -y unzip
#
#curl -sLo /var/tmp/t.zip "${release}" 
#sudo unzip /var/tmp/t.zip -d /usr/local/bin/
#rm /var/tmp/t.zip
#
