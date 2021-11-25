#!/bin/bash -x

. ./apt/no-desktop.sh
sudo apt update && sudo apt install -y \
    $PYTHON_PACKAGES $UTILITIES $C_PACKAGES $JAVA_PACKAGES $RUBY_PACKAGES

bash -x ./other/git.sh
bash -x ./other/bat.sh
bash -x ./other/ripgrep.sh
bash -x ./other/utnso.sh
bash -x ./other/docker.sh
bash -x ./other/ohmyzsh.sh
bash -x ./other/node.sh
bash -x ./other/ruby.sh

sudo update-alternatives --config java
