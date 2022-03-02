#!/bin/bash -x

set -e

source ./utils/functions.sh

# Basics
install wget curl git-all testdisk usb-creator-gtk dconf-editor apt-transport-https
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"

if [ $MINT ]; then
  install blueman
  sudo apt remove -y blueberry
fi

git config --global credential.helper store
git config --global user.email "aguseranieri@gmail.com"
git config --global user.name "Agustin Ranieri"

# Bat
install_dpkg "https://github.com/sharkdp/bat/releases/latest/download/bat-musl_$(gh_latest_tag sharkdp/bat | sed 's/v//')_amd64.deb"

# Chrome
install_dpkg "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

# Discord
install_dpkg "https://discordapp.com/api/download?platform=linux&format=deb"

# Docker
install ca-certificates gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
if [ $MINT ]; then
  sh -c "echo $(cat ./apt/docker.mint.list)" | sudo tee /etc/apt/sources.list.d/docker.list
else
  sh -c "echo $(cat ./apt/docker.list)" | sudo tee /etc/apt/sources.list.d/docker.list
fi
install docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER
echo "run 'docker run hello-world' to test docker installation"
newgrp -l

# DotNET
install_dpkg https://packages.microsoft.com/config/ubuntu/21.04/packages-microsoft-prod.deb
install dotnet-sdk-6.0

# Java
install maven openjdk-8-jdk graphviz
sudo update-alternatives --config java

# JetBrains
if [ $MINT ]; then
  sudo rm /etc/apt/preferences.d/nosnap.pref
fi
install snapd
sudo snap install intellij-idea-ultimate --classic
sudo snap install rider --classic

# Python
install python3 python3-pip python3-setuptools python3-wheel

# Ripgrep
install_dpkg "https://github.com/BurntSushi/ripgrep/releases/latest/download/ripgrep_$(gh_latest_tag BurntSushi/ripgrep | sed 's/v//')_amd64.deb"

# Spotify
curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add -
sudo cp ./apt/spotify.list /etc/apt/sources.list.d/spotify.list
install spotify-client

# Steam
install_dpkg "https://cdn.akamai.steamstatic.com/client/installer/steam.deb"

# UTNSO
install make cmake valgrind libreadline-dev entr

git clone https://github.com/mumuki/cspec.git
make -C cspec
sudo make install -C cspec
remove cspec

git clone https://github.com/sisoputnfrba/so-commons-library.git
make -C so-commons-library debug
make install -C so-commons-library
remove so-commons-library

# VirtualBox
# install virtualbox
# install virtualbox-ext-pack

# Visual Studio Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo cp ./apt/vscode.list /etc/apt/sources.list.d/vscode.list
remove packages.microsoft.gpg
install code

# Zoom
install_dpkg "https://zoom.us/client/latest/zoom_amd64.deb"

########################################################################################################################

# Oh My Zsh
install zsh
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
chsh -s `which zsh`

########################################################################################################################

zsh ./install.zsh
