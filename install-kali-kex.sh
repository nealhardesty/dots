#!/bin/sh



#dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
#dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all
# wsl --set-default-version 2
# wsl --install --distribution kali-linux

# https://www.kali.org/docs/wsl/win-kex/

sudo apt install -y kali-win-kex
sudo apt install -y kali-linux-large
