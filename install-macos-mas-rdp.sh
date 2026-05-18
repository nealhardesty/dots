#!/usr/bin/env bash

set -e

command -v mas &>/dev/null || { echo "mas is not installed."; exit 1; }

# Windows App (formerly Microsoft Remote Desktop)
mas install 1295203466
