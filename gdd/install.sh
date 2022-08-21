#!/usr/bin/env bash

set -e

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

sudo add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/20.04/mssql-server-preview.list)"
wget -qO- https://packages.microsoft.com/config/ubuntu/20.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
sudo add-apt-repository -y ppa:git-core/ppa

sudo apt-get update -y

sudo apt-get install -y \
git-all \
mssql-server \
mssql-tools \
net-tools \
ssh \
unixodbc-dev

sudo ssh-keygen -A
sudo /etc/init.d/ssh start

echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc

sudo /opt/mssql/bin/mssql-conf setup
