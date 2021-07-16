#!/bin/bash

# Allow snaps for Linux Mint
sudo rm /etc/apt/preferences.d/nosnap.pref

# Apt packages
sudo apt update
sudo apt install -y python3 python3-pip python3-setuptools python3-wheel rofi zsh ripgrep ranger htop git-all make cmake valgrind libreadline-dev maven openjdk-8-jdk graphviz virtualbox testdisk snapd blueman

sudo apt remove -y blueberry

# Snaps
sudo snap install code --classic
sudo snap install intellij-idea-ultimate --classic
sudo snap install pycharm-professional --classic
sudo snap install spotify
sudo snap install discord
sudo snap install zoom-client

# Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb 
rm google-chrome-stable_current_amd64.deb 

# Git credentials
git config --global credential.helper store
git config --global user.email "aguseranieri@gmail.com"
git config --global user.name "Agustin Ranieri"

# Bat (check version!)
BATVERSION=0.18.2
wget https://github.com/sharkdp/bat/releases/download/v$(BATVERSION)/bat-musl_$(BATVERSION)_amd64.deb
sudo dpkg -i bat-musl_$(BATVERSION)_amd64.deb 
rm bat-musl_$(BATVERSION)_amd64.deb 

# CSpec
git clone https://github.com/mumuki/cspec.git
make -C cspec
sudo make install -C cspec
rm -rf cspec

# Commons
git clone https://github.com/sisoputnfrba/so-commons-library.git 
make -C so-commons-library debug
sudo make install -C so-commons-library
rm -rf so-commons-library

# Oh my zsh
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
chsh -s `which zsh`

# Dual boot time
sudo timedatectl set-local-rtc 1

# Reboot
sudo shutdown -r 0
