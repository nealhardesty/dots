#!/bin/bash

set -e

# See https://medium.com/mkdir-awesome/how-to-install-x86-64-homebrew-packages-on-apple-m1-macbook-54ba295230f

if [ $(arch) == "arm64" ]; then
  softwareupdate --install-rosetta --agree-to-license
  echo Installing Homebrew AMD64 on ARM64...

  cd ~/Downloads
  mkdir homebrew
  curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew

  sudo mv homebrew /usr/local/homebrew

  echo Adding path to ~/.zshrc.local
  echo "alias xbrew='arch -x86_64 /usr/local/homebrew/bin/brew'" >> ${HOME}/.zshrc.local
  echo "alias xbrew='arch -x86_64 /usr/local/homebrew/bin/brew'" >> ${HOME}/.bashrc.local
  echo "Added 'xbrew' as an amd64 alias for homebrew"


  echo Note, amd64 homebrew installs in /usr/local/homebrew.

else
  echo Not arm64 architecture, no need AMD64 Homebrew
fi
