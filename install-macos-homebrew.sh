#!/bin/bash

set -e

if command -v brew &>/dev/null; then
  echo "Homebrew already installed, skipping."
else
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi
