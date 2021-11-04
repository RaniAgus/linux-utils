#!/bin/bash -x

# Bat (check version!)
BATVERSION="0.18.3"
wget https://github.com/sharkdp/bat/releases/download/v${BATVERSION}/bat-musl_${BATVERSION}_amd64.deb
sudo dpkg -i bat-musl_${BATVERSION}_amd64.deb
rm bat-musl_${BATVERSION}_amd64.deb
