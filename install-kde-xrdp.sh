#!/bin/sh -e

# https://www.hiroom2.com/ubuntu-2004-xrdp-kde-en

sudo apt install -y xrdp
sudo sed -e 's/^new_cursors=true/new_cursors=false/g' -i /etc/xrdp/xrdp.ini
sudo systemctl enable xrdp
sudo systemctl restart xrdp

echo "startplasma-x11" > ~/.xsession
D=/usr/share/plasma:/usr/local/share:/usr/share:/var/lib/snapd/desktop
C=/etc/xdg/xdg-plasma:/etc/xdg
C=${C}:/usr/share/kubuntu-default-settings/kf5-settings
cat <<EOF > ~/.xsessionrc
export XDG_SESSION_DESKTOP=KDE
export XDG_DATA_DIRS=${D}
export XDG_CONFIG_DIRS=${C}
EOF

cat <<EOF | \
  sudo tee /etc/polkit-1/localauthority/50-local.d/xrdp-NetworkManager.pkla
[xrdp-Networkmanager]
Identity=unix-group:sudo
Action=org.freedesktop.NetworkManager.network-control
ResultAny=no
ResultInactive=yes
ResultActive=yes
EOF

cat <<EOF | sudo tee /etc/polkit-1/localauthority/50-local.d/xrdp-packagekit.pkla
[xrdp-packagekit]
Identity=unix-group:sudo
Action=org.freedesktop.packagekit.system-sources-refresh
ResultAny=no
ResultInactive=yes
ResultActive=yes
EOF

sudo systemctl restart polkit
