#!/bin/bash

set -e

if [ $MINT ]; then
  sudo apt remove -y blueberry
fi

RM=rm -rfv
INSTALL=sudo apt update && sudo apt install -y

install_dpkg() {
  URL=${1:?}
  wget -O ./temp.deb "${URL}"
  sudo dpkg -i ./temp.deb
  $(RM) ./temp.deb
}

gh_latest_tag() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

# Basics
$(INSTALL) wget curl git-all testdisk
git config --global credential.helper store
git config --global user.email "aguseranieri@gmail.com"
git config --global user.name "Agustin Ranieri"

# Bat
install_dpkg https://github.com/sharkdp/bat/releases/latest/download/bat-musl_$(gh_latest_tag sharkdp/bat | sed 's/v//')_amd64.deb

# Chrome
install_dpkg https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

# Discord
install_dpkg "https://discordapp.com/api/download?platform=linux&format=deb"

# Docker
$(INSTALL) apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
if [ $MINT ]; then
  sh -c "echo $(cat ./apt/docker.mint.list)" | sudo tee /etc/apt/sources.list.d/docker.list
else
  sh -c "echo $(cat ./apt/docker.list)" | sudo tee /etc/apt/sources.list.d/docker.list
fi
$(INSTALL) docker-ce docker-ce-cli containerd.io
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
docker run hello-world

# Java
$(INSTALL) maven openjdk-8-jdk graphviz
sudo update-alternatives --config java

# JetBrains
if [ $MINT ]; then
  sudo rm /etc/apt/preferences.d/nosnap.pref
  $(INSTALL) snapd
fi
sudo snap install intellij-idea-ultimate --classic
sudo snap install rider --classic

# Python
$(INSTALL) python3 python3-pip python3-setuptools python3-wheel

# Ripgrep
install_dpkg https://github.com/BurntSushi/ripgrep/download/latest/ripgrep_$(gh_latest_tag BurntSushi/ripgrep | sed 's/v//')_amd64.deb

# Spotify
curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add -
sudo mv ./apt/spotify.list /etc/apt/sources.list.d/spotify.list
$(INSTALL) spotify-client

# Steam
install_dpkg https://cdn.akamai.steamstatic.com/client/installer/steam.deb

# UTNSO
$(INSTALL) make cmake valgrind libreadline-dev entr

git clone https://github.com/mumuki/cspec.git
make -C cspec
sudo make install -C cspec
$(RM) cspec

git clone https://github.com/sisoputnfrba/so-commons-library.git
make -C so-commons-library debug
make install -C so-commons-library
$(RM) so-commons-library

# VirtualBox
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
$(INSTALL) virtualbox-6.1

# Visual Studio Code
$(INSTALL) apt-transport-https
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo mv ./apt/vscode.list /etc/apt/sources.list.d/vscode.list
$(RM) packages.microsoft.gpg
$(INSTALL) code

# Zoom
install_dpkg "https://zoom.us/client/latest/zoom_amd64.deb"

########################################################################################################################

# Oh My Zsh
$(INSTALL) zsh wget
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
chsh -s $(which zsh)

########################################################################################################################

# Node
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/$(gh_latest_tag nvm-sh/nvm)/install.sh | bash
cat ./aliases/nvm.sh >> ~/.zshrc
source ~/.zshrc
nvm install --lts

sudo ln -s "$(type -a nvm | awk '{ print $NF }')" "/usr/local/bin/nvm"
sudo ln -s "$(type -a node | awk '{ print $NF }')" "/usr/local/bin/node"
sudo ln -s "$(type -a npm | awk '{ print $NF }')" "/usr/local/bin/npm"

# Ranger
pip install ranger-fm
sudo ln -s $HOME/.local/bin/ranger /usr/local/bin/ranger
cat ./aliases/ranger.sh >> ~/.zshrc

# Ruby
$(INSTALL) libssl-dev
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
cat ./aliases/ruby.sh >> ~/.zshrc
~/.rbenv/bin/rbenv init >> ~/.zshrc
~/.rbenv/bin/rbenv install -l | grep -v "-" | tail -1 | xargs ~/.rbenv/bin/rbenv install

########################################################################################################################

sudo timedatectl set-local-rtc 1
echo "Remember to reboot! 'sudo shutdown -r 0'"
