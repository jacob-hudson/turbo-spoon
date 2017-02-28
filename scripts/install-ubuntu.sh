#!/bin/bash

sudo apt-get -y install git
git clone "https://github.com/dtrace4linux/linux.git" dtrace
cd dtrace
tools/get-deps.pl
make all
sudo make install
sudo make load
