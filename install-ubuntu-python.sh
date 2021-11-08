#!/bin/bash

VERSION=3.9.8

sudo apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-de make

cd /tmp
wget https://www.python.org/ftp/python/${VERSION}/Python-${VERSION}.tgz
tar xzvf Python-${VERSION}.tgz
cd Python-${VERSION}

./configure --enable-optimizations

make -j 8

sudo make altinstall # do not overwrite system python
#sudo make install # overwries the system python

python3.9 --version
