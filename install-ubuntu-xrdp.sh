#!/usr/bin/env bash

sudo apt install -y xrdp xorgxrdp

sudo ufw allow 3389


# See https://c-nergy.be/blog/?p=15978

#All Ubuntu version
sudo bash -c "cat >/etc/polkit-1/localauthority/50-local.d/45-allow.colord.pkla" <<EOF
[Allow Colord All Users]
Identity=unix-user:*
Action=org.freedesktop.color-manager.create-device;org.freedesktop.color-manager.create-profile;org.freedesktop.color-manager.delete-device;org.freedesktop.color-manager.delete-profile;org.freedesktop.color-manager.modify-device;org.freedesktop.color-manager.modify-profile
ResultAny=no
ResultInactive=no
ResultActive=yes
EOF

#Specific Versions
if [[ "$version" = *"Ubuntu 20.10"* ]] || [[ "$version" = *"Ubuntu 20.04"* ]] ;
then
  sudo bash -c "cat >/etc/polkit-1/localauthority/50-local.d/46-allow-update-repo.pkla" <<EOF
[Allow Package Management All Users]
Identity=unix-user:*
Action=org.freedesktop.packagekit.system-sources-refresh
ResultAny=yes
ResultInactive=yes
ResultActive=yes
EOF
fi

# complains about access to /etc/xrdp/key.pem otherwise :shrug:
sudo adduser xrdp ssl-cert

sudo systemctl restart xrdp


# Setup .xsession
echo "/usr/bin/gnome-session" > ~/.xsession
