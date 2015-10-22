#!/bin/bash

GITREPO=$(cd $(dirname $0); pwd)

#find $GITREPO -maxdepth 1 -type f -name '.*' -exec echo {}  \;
find $GITREPO -maxdepth 1 -type f -name '.*' -exec ln -sfv {} ~ \;

mkdir -p ~/.ssh
ln -sfv $GITREPO/.ssh/config ~/.ssh/config

