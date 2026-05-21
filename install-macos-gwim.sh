#!/bin/sh


cd /var/tmp
git clone git@github.com:nealhardesty/gwim
cd gwim
make install
open /Applications/GWiM.app
