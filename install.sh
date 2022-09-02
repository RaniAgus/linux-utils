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

if [ $MINT ]; then
  sudo rm /etc/apt/preferences.d/nosnap.pref
fi

# Basics
apt_install apt-transport-https curl dconf-editor drawing htop jq p7zip-full ripgrep software-properties-common testdisk tree usb-creator-gtk wget
flatpak install -y flathub org.kde.kdenlive

# Fonts
bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"

# Git
sudo add-apt-repository -y ppa:git-core/ppa
apt_install git-all
dpkg_install "https://github.com/GitCredentialManager/git-credential-manager/releases/latest/download/gcmcore-linux_amd64.$(gh_latest_tag GitCredentialManager/git-credential-manager).deb"
git-credential-manager-core configure
gpg --generate-key
read -p "Enter generated gpg key: " gpgkey
pass init $gpgkey

git config --global init.defaultBranch main
git config --global credential.credentialStore gpg
git config --global user.email "aguseranieri@gmail.com"
git config --global user.name "Agustin Ranieri"

# GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
apt_install gh

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
if [ $MINT ]; then
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(cat /etc/upstream-release/lsb-release | grep "DISTRIB_CODENAME" | cut -d '=' -f2) stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list
else
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list
fi
apt_install docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo usermod -aG docker $USER
# run 'docker run hello-world' to test docker installation
newgrp docker

# DotNET
# dpkg_install https://packages.microsoft.com/config/ubuntu/21.04/packages-microsoft-prod.deb
# apt_install dotnet-sdk-6.0

# Java
apt_install maven openjdk-8-jdk graphviz
sudo update-alternatives --config java

# JetBrains
wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.23.11849.tar.gz
sudo tar xvzf jetbrains-toolbox-*.tar.gz -C /opt
/opt/jetbrains-toolbox-*/jetbrains-toolbox
rm jetbrains-toolbox-*.tar.gz

# Ngrok
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
apt_install ngrok

# Python
apt_install python3 python3-pip python3-setuptools python3-wheel

# Nautilus terminal
apt_install python3-nautilus python3-psutil python3-pip libglib2.0-bin dconf-editor
pip3 install --user nautilus_terminal 

# Spotify
flatpak install -y flathub com.spotify.Client
# curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add -
# echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
# install spotify-client

# UTNSO
# sudo add-apt-repository -y ppa:daniel-milde/gdu
# install gdu
apt_install make cmake valgrind libreadline-dev libcunit1 libcunit1-doc libcunit1-dev entr remake shellcheck

git clone https://github.com/mumuki/cspec.git
make -C cspec
sudo make install -C cspec
rm -rv cspec

git clone https://github.com/sisoputnfrba/so-commons-library.git
make -C so-commons-library debug install
rm -rv so-commons-library

sudo curl --create-dirs -o /usr/local/include/doctest/doctest.h \
  https://raw.githubusercontent.com/doctest/doctest/v2.4.9/doctest/doctest.h

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
