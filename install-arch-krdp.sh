#!/bin/sh

set -ex

sudo paru -S --noconfirm krdp

sudo ufw allow 3389/tcp
