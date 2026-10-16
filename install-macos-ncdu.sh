#!/bin/bash
# installs ncdu, an ncurses disk usage analyzer
# https://dev.yorhel.nl/ncdu
set -e

if ! command -v brew >/dev/null 2>&1; then
  echo "missing required dependency: brew (run install-macos-homebrew.sh first)"
  exit 1
fi

if command -v ncdu >/dev/null 2>&1; then
  echo "ncdu already installed"
else
  echo "installing ncdu"
  brew install ncdu
fi

ncdu --version
