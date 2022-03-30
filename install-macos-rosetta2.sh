#!/bin/bash

set -e 


if [ $(arch) == "arm64" ]; then
  softwareupdate --install-rosetta --agree-to-license
else
  echo Not arm64, no need for rosetta2
fi
