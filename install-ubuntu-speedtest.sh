#!/bin/sh

set -ex

cd /tmp
wget https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux-x86_64.tgz

sudo tar xvCf /usr/local/bin/ ookla-speedtest-1.2.0-linux-x86_64.tgz speedtest

rm ookla-speedtest*.tgz
