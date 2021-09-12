#!/bin/bash

mkdir -p ~/.ssh
curl https://api.github.com/users/nealhardesty/keys |jq '.[].key' >> ~/.ssh/authorized_keys
