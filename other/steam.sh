#!/bin/bash -x

wget https://cdn.akamai.steamstatic.com/client/installer/steam.deb
sudo dpkg -i steam.deb
rm steam.deb 
