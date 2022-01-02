#!/bin/bash -x

sudo rm /etc/apt/preferences.d/nosnap.pref

. ./apt/desktop.sh
. ./apt/no-desktop.sh
sudo apt update && sudo apt install -y \
    $PYTHON_PACKAGES $UTILITIES $C_PACKAGES $JAVA_PACKAGES $DESKTOP_PACKAGES $DOCKER_PACKAGES $RUBY_PACKAGES blueman

sudo apt remove -y blueberry

bash -x ./other/snaps.sh
bash -x ./other/chrome.sh
bash -x ./other/git.sh
bash -x ./other/bat.sh
bash -x ./other/ripgrep.sh
bash -x ./other/utnso.sh
bash -x ./other/docker.sh mint
bash -x ./other/ohmyzsh.sh
bash -x ./other/ranger.sh
bash -x ./other/node.sh
bash -x ./other/ruby.sh
bash -x ./other/steam.sh

sudo update-alternatives --config java
sudo timedatectl set-local-rtc 1

echo "Remember to reboot! 'sudo shutdown -r 0'"
