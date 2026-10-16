#!/bin/bash
# installs ncdu, an ncurses disk usage analyzer
# https://dev.yorhel.nl/ncdu
set -e

if ! command -v apt-get >/dev/null 2>&1; then
  echo "missing required dependency: apt-get"
  exit 1
fi

if command -v ncdu >/dev/null 2>&1; then
  echo "ncdu already installed"
else
  echo "updating apt"
  sudo apt-get update
  echo "installing ncdu"
  sudo apt-get install -y ncdu
fi

ncdu --version
