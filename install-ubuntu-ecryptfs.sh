#!/bin/bash

# https://help.ubuntu.com/community/EncryptedPrivateDirectory

sudo apt install -y ecryptfs-utils
ecryptfs-setup-private
