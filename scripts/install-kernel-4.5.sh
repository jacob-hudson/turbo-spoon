#!/bin/bash
set -ex
VER=4.5.0-040500rc6
PREFIX=http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.5-rc6-wily
REL=201602281230
wget -q ${PREFIX}/linux-headers-${VER}-generic_${VER}.${REL}_amd64.deb
wget -q ${PREFIX}/linux-headers-${VER}_${VER}.${REL}_all.deb
wget -q ${PREFIX}/linux-image-${VER}-generic_${VER}.${REL}_amd64.deb
sudo dpkg -i linux-*${VER}.${REL}*.deb
rm -f *.deb
