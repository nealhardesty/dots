#!/usr/bin/env bash

set -eo

#https://ryancreecy.com/2019/10/29/xrdp-on-mac.html

brew --help >> /dev/null || exit 2


brew install openssl xquartz automake libtool pkgconfig nasm xorgproto xorgproto

export CPPFLAGS="-I/opt/homebrew/opt/openssl/include"

# https://github.com/neutrinolabs/xrdp/issues/1461
sudo sed -I.bak -e 's/#include <X11\/fonts\/libxfont2.h>/\/\/#include <X11\/fonts\/libxfont2.h>/' /opt/X11/include/xorg/dixfontstr.h

mkdir /tmp/xrdp

cd /tmp/xrdp

curl -Lo xrdp-0.9.17.tar.gz https://github.com/neutrinolabs/xrdp/releases/download/v0.9.17/xrdp-0.9.17.tar.gz
tar xzvf xrdp-0.9.17.tar.gz 

curl -Lo xorgxrpd-0.2.17.tar.gz https://github.com/neutrinolabs/xorgxrdp/releases/download/v0.2.17/xorgxrdp-0.2.17.tar.gz
tar xzvf xorgxrpd-0.2.17.tar.gz

cd xrdp-0.9.17
./bootstrap 
./configure PKG_CONFIG_PATH=/opt/homebreww/opt/openssl/lib/pkgconfig
make
sudo make install

cd ../xorgxrdp-0.2.17/
./bootstrap
./configure PKG_CONFIG_PATH=/opt/X11/lib/pkgconfig
make
sudo make install


sudo cp /etc/xrdp/xrdp.ini /etc/xrdp/xrdp.ini.orig


cat <<EOF | sudo tee -a /etc/xrdp/xrdp.ini

[vnc-any]
name=RDP to VNC Connector
lib=libvnc.dylib
ip=127.0.0.1
port=5900
username=ask
password=ask
xserverbpp=24

EOF


# https://gist.github.com/neg2led/7ebd93549d539a2735b68c26d91db6e0

cat <<EOF | sudo tee -a /Library/LaunchDaemons/org.xrdp.xrdp-sesman.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>GroupName</key>
  <string>wheel</string>
  <key>InitGroups</key>
  <true/>
  <key>KeepAlive</key>
  <dict>
    <key>Crashed</key>
    <false/>
  </dict>
  <key>Label</key>
  <string>org.xrdp.xrdp</string>
  <key>ProcessType</key>
  <string>Background</string>
  <key>ProgramArguments</key>
  <array>
    <string>/usr/local/sbin/xrdp</string>
    <string>--nodaemon</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>UserName</key>
  <string>root</string>
</dict>
</plist>
EOF


cat <<EOF | sudo tee -a /Library/LaunchDaemons/org.xrdp.xrdp-sesman.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>GroupName</key>
  <string>wheel</string>
  <key>InitGroups</key>
  <true/>
  <key>KeepAlive</key>
  <dict>
    <key>Crashed</key>
    <false/>
  </dict>
  <key>Label</key>
  <string>org.xrdp.xrdp-sesman</string>
  <key>ProcessType</key>
  <string>Background</string>
  <key>ProgramArguments</key>
  <array>
    <string>/usr/local/sbin/xrdp-sesman</string>
    <string>--nodaemon</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>UserName</key>
  <string>root</string>
</dict>
</plist>
EOF

echo
echo Binaries are located in /usr/local/sbin/xrdp and /usr/local/sbin/xrdp-sesman
echo
echo You may want to comment out "[Xorg] [Xvnc] and [netrinordp-any] and the first [vnc-any]" sections in /etc/xrdp/xrdp.ini
echo



