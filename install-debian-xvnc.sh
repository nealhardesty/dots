#!/bin/bash

sudo apt update
sudo apt install -y xfce4 xfce4-goodies tightvncserver dbus-x11

mkdir -p ~/.vnc
cat > ~/.vnc/xstartup <<EOF
#!/bin/bash 
xrdb $HOME/.Xresources
startxfce4 &
EOF

chmod a+x ~/.vnc/xstartup

echo "Start with 'vncserver'"
