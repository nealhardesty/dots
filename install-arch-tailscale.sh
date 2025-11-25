#!/bin/sh

set -ex

sudo pacman -S --noconfirm tailscale

sudo systemctl enable --now tailscaled

sudo tailscale up

tailscale ip -4

