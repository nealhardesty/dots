#!/bin/bash



echo Installing Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"


echo Macdown markdown editor...
brew cask install macdown
