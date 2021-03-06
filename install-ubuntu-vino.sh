#!/usr/bin/env bash

sudo apt install -y vino
gsettings set org.gnome.Vino require-encryption false
gsettings set org.gnome.Vino prompt-enabled false
gsettings set org.gnome.Vino authentication-methods "['vnc']"
gsettings set org.gnome.Vino vnc-password $(echo -n $(hostname) | base64)

echo
echo password: $(hostname)
echo
echo To restrict connections to loopback only:
echo gsettings set org.gnome.Vino network-interface lo
echo

echo Start vino manually with:
echo /usr/lib/vino/vino-server
