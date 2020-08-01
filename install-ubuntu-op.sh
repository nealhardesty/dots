#!/usr/bin/env bash

curl -o /var/tmp/op.zip https://cache.agilebits.com/dist/1P/op/pkg/v1.4.0/op_linux_amd64_v1.4.0.zip

cd /var/tmp 
unzip op.zip

sudo mv -v op /usr/local/bin
rm -v op.zip op.sig
