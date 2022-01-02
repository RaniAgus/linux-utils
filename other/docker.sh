#!/bin/bash -x

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

DIST=$(lsb_release -cs)
if [ "$1" == "mint" ]; then DIST=$(cat /etc/upstream-release/lsb-release | grep "DISTRIB_CODENAME" | cut -d '=' -f2); fi

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
  https://download.docker.com/linux/ubuntu $(DIST) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker 
