#!/bin/bash

# Enable use of .xsession in GDM
cat <<EOF | sudo tee -a /usr/share/xsessions/xsession.desktop
[Desktop Entry]
Name=XSession
Comment=Use the .xsession startup script
Exec=/etc/X11/Xsession
Type=Application
DesktopNames=GNOME-Flashback;GNOME;
X-Ubuntu-Gettext-Domain=gnome-flashback
EOF
