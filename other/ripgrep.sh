#!/bin/bash -x

# Ripgrep (check version!)
RGVERSION="12.1.1"
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/${RGVERSION}/ripgrep_${RGVERSION}_amd64.deb
sudo dpkg -i ripgrep_${RGVERSION}_amd64.deb
rm ripgrep_${RGVERSION}_amd64.deb
