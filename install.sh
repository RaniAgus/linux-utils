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
  sudo rm /etc/apt/preferences.d/nosnap.pref
fi

# Basics
apt_install apt-transport-https curl dconf-editor drawing fd-find hexyl htop hyperfine jq pass p7zip-full ripgrep software-properties-common testdisk tree usb-creator-gtk wget zip
flatpak install -y flathub \
    org.kde.kdenlive \
    com.github.jeromerobert.pdfarranger \
    com.obsproject.Studio 

# Fly.io
curl -L https://fly.io/install.sh | sh

# Fonts
bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"

# Git
sudo add-apt-repository -y ppa:git-core/ppa
apt_install git-all
dpkg_install "https://github.com/git-ecosystem/git-credential-manager/releases/latest/download/gcm-linux_amd64.$(gh_latest_tag git-ecosystem/git-credential-manager).deb"
git-credential-manager-core configure
gpg --generate-key
read -p "Enter generated gpg key: " gpgkey
pass init "$gpgkey"

git config --global init.defaultBranch main
git config --global credential.credentialStore gpg
git config --global user.email "aguseranieri@gmail.com"
git config --global user.name "Agustin Ranieri"

# GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y

# Bat
dpkg_install "https://github.com/sharkdp/bat/releases/latest/download/bat-musl_$(gh_latest_tag sharkdp/bat)_amd64.deb"

# Chrome
flatpak install -y flathub com.google.Chrome
#dpkg_install "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

# Discord
flatpak install -y flathub com.discordapp.Discord
#dpkg_install "https://discordapp.com/api/download?platform=linux&format=deb"

# Docker
apt_install ca-certificates gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
if [ "$MINT" ]; then
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(grep "DISTRIB_CODENAME" /etc/upstream-release/lsb-release | cut -d '=' -f2) stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list
else
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list
fi
apt_install docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo usermod -aG docker "$USER"
echo "run 'docker run hello-world' to test docker installation"
newgrp docker

# DotNET
apt_install dotnet6

# Java
apt_install maven openjdk-8-jdk openjdk-8-source openjdk-11-jdk openjdk-11-source openjdk-17-jdk openjdk-17-source graphviz
sudo update-alternatives --config java
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install gradle 7.5.1

# JetBrains
TBA_LINK=$(curl -fsSL "https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release" | jq -r '.TBA[0].downloads.linux.link')
wget -qO- "${TBA_LINK:?}" | sudo tar xvzC /opt
/opt/jetbrains-toolbox-*/jetbrains-toolbox

# Ngrok
curl -fsSL "https://ngrok-agent.s3.amazonaws.com/ngrok.asc" | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
apt_install ngrok

# Python
apt_install python3 python3-pip python3-setuptools python3-wheel

## Nautilus terminal
apt_install python3-nautilus python3-psutil python3-pip libglib2.0-bin dconf-editor
pip3 install --user nautilus_terminal 

## Ranger
pip install ranger-fm
sudo ln -s "$HOME/.local/bin/ranger" /usr/local/bin/ranger

## yt-dlp
pip install yt-dlp

# Spotify
flatpak install -y flathub com.spotify.Client
# curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add -
# echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
# install spotify-client

# SisOp
# sudo add-apt-repository -y ppa:daniel-milde/gdu
# install gdu
apt_install make clang-format clang-tidy cmake entr libreadline-dev libcunit1 libcunit1-doc libcunit1-dev meson ninja-build remake shellcheck valgrind

git clone https://github.com/mumuki/cspec.git
make -C cspec
sudo make install -C cspec
rm -rv cspec

git clone https://github.com/sisoputnfrba/so-commons-library.git
make -C so-commons-library debug install
rm -rv so-commons-library

sudo mkdir /usr/local/include/doctest
curl -fsSL "https://raw.githubusercontent.com/doctest/doctest/v2.4.8/doctest/doctest.h" \
  | sudo tee /usr/local/include/doctest/doctest.h > /dev/null

# Visual Studio Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
 | sudo tee /etc/apt/sources.list.d/vscode.list
rm -v packages.microsoft.gpg
apt_install code

# Zoom
flatpak install -y flathub us.zoom.Zoom

########################################################################################################################

# Oh My Zsh
apt_install zsh
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
chsh -s `which zsh`
