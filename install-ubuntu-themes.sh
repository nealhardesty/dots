#!/bin/bash

#sudo add-apt-repository -y -n ppa:noobslab/themes
#sudo add-apt-repository -y -n ppa:noobslab/icons
#sudo add-apt-repository -y -n ppa:tista/adapta
#sudo apt install -y pop-theme gnome-tweaks gnome-shell-extensions arc-theme arc-icons adapta-gtk-theme flat-remix-themes flat-remix-icons
# see extensions.gnome.org

sudo add-apt-repository -y -n ppa:system76/pop
sudo apt update -y

sudo apt install -y git gnome-tweaks gnome-shell-extensions pop-theme

git clone https://github.com/rtlewis88/rtl88-Themes.git ~/.themes && rm -rvf ~/.themes/.git ~/.themes/*.jpg ~/.themes/*.md


