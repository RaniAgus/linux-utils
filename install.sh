#!/bin/bash -x

set -e

install() {
  sudo apt update && sudo apt install -y "$@"
}

remove() {
  rm -rfv "$@"
}

install_dpkg() {
  URL=${1:?}
  NAME=./$RANDOM.deb
  wget -O ${NAME} "${URL}"
  sudo apt install -y ${NAME}
  remove ${NAME}
}

gh_latest_tag() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

if [ $MINT ]; then
  sudo rm /etc/apt/preferences.d/nosnap.pref
fi

# Basics
install apt-transport-https curl dconf-editor drawing htop p7zip-full ripgrep software-properties-common testdisk tree usb-creator-gtk wget
flatpak install -y flathub org.kde.kdenlive

# Fonts
bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"

if [ $MINT ]; then
  install blueman
  sudo apt remove -y blueberry
fi

# Git
sudo add-apt-repository -y ppa:git-core/ppa
install git-all
install_dpkg "https://github.com/GitCredentialManager/git-credential-manager/releases/latest/download/gcmcore-linux_amd64.$(gh_latest_tag GitCredentialManager/git-credential-manager | sed 's/v//g').deb"
git-credential-manager-core configure
gpg --generate-key
read -p "Enter generated gpg key: " $gpgkey
pass init $gpgkey

git config --global init.defaultBranch main
git config --global credential.credentialStore gpg
git config --global user.email "aguseranieri@gmail.com"
git config --global user.name "Agustin Ranieri"

# Bat
install_dpkg "https://github.com/sharkdp/bat/releases/latest/download/bat-musl_$(gh_latest_tag sharkdp/bat | sed 's/v//g')_amd64.deb"

# Chrome
flatpak install -y flathub com.google.Chrome
#install_dpkg "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

# Discord
flatpak install -y flathub com.discordapp.Discord
#install_dpkg "https://discordapp.com/api/download?platform=linux&format=deb"

# Docker
install ca-certificates gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
if [ $MINT ]; then
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(cat /etc/upstream-release/lsb-release | grep "DISTRIB_CODENAME" | cut -d '=' -f2) stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list
else
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list
fi
install docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER
# run 'docker run hello-world' to test docker installation
newgrp docker

# DotNET
# install_dpkg https://packages.microsoft.com/config/ubuntu/21.04/packages-microsoft-prod.deb
# install dotnet-sdk-6.0

# Java
install maven openjdk-8-jdk graphviz
sudo update-alternatives --config java

# JetBrains
wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.23.11849.tar.gz
sudo tar xvzf jetbrains-toolbox-*.tar.gz -C /opt
/opt/jetbrains-toolbox-*/jetbrains-toolbox
rm jetbrains-toolbox-*.tar.gz

# Ngrok
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
install ngrok

# Python
install python3 python3-pip python3-setuptools python3-wheel

# Spotify
flatpak install -y flathub com.spotify.Client
# curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add -
# echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
# install spotify-client

# UTNSO
# sudo add-apt-repository -y ppa:daniel-milde/gdu
# install gdu
install make cmake valgrind libreadline-dev libcunit1 libcunit1-doc libcunit1-dev entr remake

git clone https://github.com/mumuki/cspec.git
make -C cspec
sudo make install -C cspec
remove cspec

git clone https://github.com/sisoputnfrba/so-commons-library.git
make -C so-commons-library debug
make install -C so-commons-library
remove so-commons-library

# Visual Studio Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
 | sudo tee /etc/apt/sources.list.d/vscode.list
remove packages.microsoft.gpg
install code

# Zoom
flatpak install -y flathub us.zoom.Zoom

########################################################################################################################

# Oh My Zsh
install zsh
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
chsh -s `which zsh`
