#!/bin/bash

set -x

# DEBIAN_FRONTEND=noninteractive sudo apt install -y dconf-editor

#dconf write /org/gnome/desktop/wm/keybindings/begin-move '<Super>Down'
#dconf write /org/gnome/desktop/wm/keybindings/toggle-maximized '<Super>Up'

dconf load / <<EOF
[org/gnome/desktop/wm/keybindings]
begin-move='<Super>Down'
toggle-fullscreen=['<Super>Return']
toggle-maximized=['<Super>Up']

[ca/desrt/dconf-editor]
show-warning=false

[org/gnome/desktop/calendar]
show-weekdate=true

[org/gnome/desktop/input-sources]
sources=[('xkb', 'us')]
xkb-options=['caps:escape']

[org/gnome/desktop/interface]
clock-show-seconds=true
clock-show-weekday=true
enable-animations=false
gtk-theme='Adwaita-dark'
show-battery-percentage=true
text-scaling-factor=1.0

[org/gnome/desktop/peripherals/touchpad]
two-finger-scrolling-enabled=true

[org/gnome/desktop/sound]
allow-volume-above-100-percent=true

[org/gnome/desktop/wm/preferences]
button-layout='close,minimize,maximize:'

[org/gnome/nautilus/preferences]
default-folder-viewer='list-view'
show-image-thumbnails='always'

[org/gnome/settings-daemon/plugins/power]
ambient-enabled=false
power-button-action='suspend'
sleep-inactive-ac-timeout=3600
sleep-inactive-ac-type='nothing'
sleep-inactive-battery-timeout=3600

[org/gnome/shell]
favorite-apps=['org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'gnome-control-center.desktop']

[org/gnome/shell/extensions/dash-to-dock]
dash-max-icon-size=24

EOF




# Install nord theme for gnome-terminal
cd /var/tmp \
  && git clone https://github.com/arcticicestudio/nord-gnome-terminal.git \
  && cd nord-gnome-terminal/src \
  && ./nord.sh
