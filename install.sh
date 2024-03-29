#!/bin/bash -x

set -e

apt_install() {
  sudo apt-get update && sudo apt-get install -y "$@"
}

dpkg_install() {
  URL=${1:?}
  NAME=./$RANDOM.deb
  wget -O ${NAME} "${URL}"
  sudo apt install -y ${NAME}
  rm -v ${NAME}
}

gh_latest_tag() {
  curl -fsSL "https://api.github.com/repos/$1/releases/latest" | jq -r '.tag_name' | sed 's/v//g'
}

if [ "$MINT" ]; then
  LSB_RELEASE=$(grep "DISTRIB_CODENAME" /etc/upstream-release/lsb-release | cut -d '=' -f2)
else
  LSB_RELEASE=$(lsb_release -cs)
fi

# use this to skip successful steps
if false; then
fi

if [ "$MINT" ]; then
  sudo rm /etc/apt/preferences.d/nosnap.pref
fi

# Basics
apt_install apt-transport-https curl chntpw dconf-editor drawing fd-find gnome-shell-extension-prefs hexyl htop hyperfine jq pass p7zip-full rename ripgrep silversearcher-ag snapd software-properties-common testdisk tree usb-creator-gtk wget zip

if [ "$NOSNAP" ]; then
  flatpak install -y flathub \
      org.kde.kdenlive \
      com.github.jeromerobert.pdfarranger \
      com.obsproject.Studio \
      org.videolan.VLC
else
  sudo snap install kdenlive pdfarranger obs-studio vlc
fi
sudo sed -i 's/#IdleTimeout=30/IdleTimeout=0/g' /etc/bluetooth/input.conf

# 1Password
curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
  sudo gpg --yes --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" |
  sudo tee /etc/apt/sources.list.d/1password.list
sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | \
  sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
  sudo gpg --yes --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
apt_install 1password 1password-cli

mkdir -p ~/.ssh
chmod 600 ~/.ssh
tee ~/.ssh/config >> /dev/null << EOF
Host *
        IdentityAgent ~/.1password/agent.sock
EOF
chmod 600 ~/.ssh/config

mkdir -p ~/.config/autostart
cp ./dotfiles/autostart/1password.desktop ~/.config/autostart/1password.desktop

# Code
sudo snap install code --classic

# Fonts
bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"

# Git
sudo add-apt-repository -y ppa:git-core/ppa

apt_install git-all
# dpkg_install "https://github.com/git-ecosystem/git-credential-manager/releases/latest/download/gcm-linux_amd64.$(gh_latest_tag git-ecosystem/git-credential-manager).deb"
# git-credential-manager configure
# gpg --generate-key
# read -r -p "Enter generated gpg key: " gpgkey
# pass init "$gpgkey"

read -r -p 'Enter SSH public key: ' SSH_PUB_KEY

git config --global init.defaultBranch main
# git config --global credential.credentialStore gpg
git config --global user.email "aguseranieri@gmail.com"
git config --global user.name "Agustin Ranieri"
git config --global credential.username "RaniAgus"
git config --global gpg.format ssh
git config --global user.signingkey "$SSH_PUB_KEY"
git config --global commit.gpgsign true
git config --global gpg.ssh.program "/opt/1Password/op-ssh-sign"
git config --global core.protectNTFS false

# GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
apt_install gh

# Bat
dpkg_install "https://github.com/sharkdp/bat/releases/latest/download/bat-musl_$(gh_latest_tag sharkdp/bat)_amd64.deb"

# Chrome
flatpak install -y flathub com.google.Chrome
# dpkg_install https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

# Discord
if [ "$NOSNAP" ]; then
  flatpak install -y flathub com.discordapp.Discord
else
  sudo snap install discord
fi

# Docker
apt_install ca-certificates gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu ${LSB_RELEASE:?} stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list
apt_install docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo usermod -aG docker "$USER"
echo "run 'docker run hello-world' to test docker installation"
newgrp docker

# DotNET
apt_install dotnet6

# Fly.io
curl -L https://fly.io/install.sh | sh

# Golang
sudo rm -rf /usr/local/go
wget -qO- "https://go.dev/dl/$(curl -fsSL 'https://golang.org/VERSION?m=text' | head -n1).linux-amd64.tar.gz" \
  | sudo tar xvzC /usr/local
tee ~/.cobra.yaml >> /dev/null << EOF
author: Agustin Ranieri <aguseranieri@gmail.com>
license: MIT
EOF
# To go get packages from private repos using ssh -- https://stackoverflow.com/a/38672481
git config --global url."git@github.com:".insteadOf "https://github.com/"
git config --global url."git@bitbucket.org:".insteadOf "https://bitbucket.org/"

# Java
wget -O- https://apt.corretto.aws/corretto.key | sudo apt-key add -
sudo add-apt-repository -y 'deb https://apt.corretto.aws stable main'
apt_install maven java-17-amazon-corretto-jdk java-11-amazon-corretto-jdk java-1.8.0-amazon-corretto-jdk graphviz
# sudo update-alternatives --config java
curl -s "https://get.sdkman.io" | bash
# shellcheck disable=SC1091
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install gradle
sdk install quarkus

# JetBrains
TBA_LINK=$(curl -fsSL "https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release" | jq -r '.TBA[0].downloads.linux.link')
wget -qO- "${TBA_LINK:?}" | sudo tar xvzC /opt
# shellcheck disable=SC2211
/opt/jetbrains-toolbox-*/jetbrains-toolbox

# Ngrok
curl -fsSL "https://ngrok-agent.s3.amazonaws.com/ngrok.asc" | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
apt_install ngrok

# Posman
if [ "$NOSNAP" ]; then
  flatpak install -y flathub com.getpostman.Postman
else
  sudo snap install postman
fi

# Protocol buffers
apt_install protobuf-compiler

# Python
apt_install python3 python3-pip python3-setuptools python3-wheel

## Ranger
pip install ranger-fm

## yt-dlp
apt_install ffmpeg
pip install yt-dlp

## yq
pip install yq

# Spotify
if [ "$NOSNAP" ]; then
  flatpak install -y flathub com.spotify.Client
else
  sudo snap install spotify
fi

# SisOp
# sudo add-apt-repository -y ppa:daniel-milde/gdu
# install gdu
apt_install make clang-format clang-tidy cmake entr libreadline-dev libcunit1 libcunit1-doc libcunit1-dev meson ninja-build remake shellcheck valgrind

git clone https://github.com/mumuki/cspec.git
make -C cspec
sudo make install -C cspec
rm -rfv cspec

git clone https://github.com/sisoputnfrba/so-commons-library.git
make -C so-commons-library debug install
rm -rfv so-commons-library

sudo mkdir /usr/local/include/doctest
curl -fsSL "https://raw.githubusercontent.com/doctest/doctest/v2.4.8/doctest/doctest.h" \
  | sudo tee /usr/local/include/doctest/doctest.h > /dev/null

# TailwindCSS
curl -sLO https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-linux-x64
chmod +x tailwindcss-linux-x64
sudo mv tailwindcss-linux-x64 /usr/local/bin/tailwindcss

# VirtualBox
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian ${LSB_RELEASE:?} contrib" \
  | sudo tee /etc/apt/sources.list.d/virtualbox.list
wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc \
  | sudo gpg --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg --dearmor
apt_install virtualbox-7.0

# Zoom
flatpak install -y flathub us.zoom.Zoom

########################################################################################################################

# Oh My Zsh
apt_install zsh
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
# shellcheck disable=SC2006,SC2046
chsh -s `which zsh`
