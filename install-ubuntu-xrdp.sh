#!/usr/bin/env bash

sudo apt install xrdp xorgxrdp

cat <<MOOSE | sudo tee -a /etc/xrdp/xrdp.ini
[xrdpvino]
name=Vino-Session
lib=libvnc.so
username=${USER}
password=ask
ip=127.0.0.1
port=5900
MOOSE
