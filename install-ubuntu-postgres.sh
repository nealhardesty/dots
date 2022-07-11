#!/bin/bash

sudo apt install -y curl

if [ -d /etc/apt/trusted.gpg.d/ ]; then
  curl https://www.postgresql.org/media/keys/ACCC4CF8.asc |sudo tee /etc/apt/trusted.gpg.d/postgres.asc
else
  curl https://www.postgresql.org/media/keys/ACCC4CF8.asc |sudo apt-key add -
fi

echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list

echo 

sudo apt-get update
sudo apt-get install -y postgresql-13
