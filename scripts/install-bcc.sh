#!/bin/bash
set -eux

# install runtime dependencies
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D4284CDD
echo "deb [trusted=yes] http://52.8.15.63/apt/nightly trusty main" | sudo tee /etc/apt/sources.list.d/iovisor.list
sudo apt-get update
sudo apt-get install -y bcc-tools git

if ! [[ -d "$HOME/pyroute2" ]]; then
  git clone https://github.com/svinota/pyroute2 "$HOME/pyroute2"
  pushd "$HOME/pyroute2"
  sudo make install
  popd
fi
