#!/bin/bash

sed -i '/config.vm.box/c\config.vm.box = "kaorimatz/ubuntu-16.10-amd64"' Vagrantfile
