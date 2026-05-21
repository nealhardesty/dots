#!/usr/bin/env bash

set -e

command -v brew &>/dev/null || { echo "Homebrew is not installed."; exit 1; }

brew install --cask android-studio
