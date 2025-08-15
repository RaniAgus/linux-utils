#!/bin/bash -x

set -e

gh_latest_tag() {
  curl -fsSL "https://api.github.com/repos/$1/releases/latest" | jq -r '.tag_name' | sed 's/v//g'
}

flatpak install -y flathub \
  com.discordapp.Discord \
  com.getpostman.Postman \
  org.kde.kdenlive \
  org.gnome.Extensions \
  net.pcsx2.PCSX2 \
  com.github.jeromerobert.pdfarranger \
  com.obsproject.Studio \
  org.videolan.VLC \
  us.zoom.Zoom

sed -i 's/enableMiniWindow=.*/enableMiniWindow=false/' ~/.var/app/us.zoom.Zoom/config/zoomus.conf

sudo dnf update -y

sudo dnf -y install dnf-plugins-core ffmpeg python3 python3-pip python3-setuptools python3-wheel jq dnf-automatic

echo -e "[commands]\napply_updates=True" | sudo tee /etc/dnf/automatic.conf

# Chrome

sudo rpm --import https://dl.google.com/linux/linux_signing_key.pub
sudo dnf install https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm

# Code

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" \
  | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

sudo dnf install -y code

# 1password

sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc

echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\ngpgkey=https://downloads.1password.com/linux/keys/1password.asc" \
  | sudo tee /etc/yum.repos.d/1password.repo > /dev/null

sudo dnf install -y 1password 1password-cli

mkdir -p ~/.config/autostart
cat <<EOF | nano ~/.config/autostart/1password.desktop
[Desktop Entry]
Name=1Password
Exec=1password --silent %U
Terminal=false
Type=Application
Icon=1password
StartupWMClass=1Password
Comment=Password manager and secure wallet
MimeType=x-scheme-handler/onepassword;
Categories=Office;
EOF

# JetBrains Mono

bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"

# Git

git config --global init.defaultBranch main
git config --global user.email "aguseranieri@gmail.com"
git config --global user.name "Agustin Ranieri"
git config --global credential.username "RaniAgus"
git config --global gpg.format ssh

# C/C++

sudo dnf install -y gcc gcc-c++ gdb make entr readline-devel shellcheck valgrind clang-tidy clang-format

git clone https://github.com/mumuki/cspec.git
make -C cspec
sudo make install -C cspec
rm -rfv cspec

git clone https://github.com/sisoputnfrba/so-commons-library.git
make -C so-commons-library debug install
rm -rfv so-commons-library

sudo mkdir /usr/local/include/doctest
curl -fsSL "https://raw.githubusercontent.com/doctest/doctest/v2.4.12/doctest/doctest.h" \
  | sudo tee /usr/local/include/doctest/doctest.h > /dev/null

# Docker

#sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
#sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
#sudo systemctl enable --now docker
#sudo docker run hello-world
#sudo groupadd docker
#sudo usermod -aG docker $USER

sudo dnf install -y podman-compose

systemctl --user enable podman.socket
systemctl --user start podman.socket

# echo "Run 'docker run hello-world' to verify Docker installation."
# newgrp docker

# Go

wget -qO- "https://go.dev/dl/$(curl -fsSL 'https://golang.org/VERSION?m=text' | head -n1).linux-amd64.tar.gz"   | sudo tar xvzC /usr/local
git config --global url."git@github.com:".insteadOf "https://github.com/"
git config --global url."git@bitbucket.org:".insteadOf "https://bitbucket.org/"

# Java

cat <<EOF > /etc/yum.repos.d/adoptium.repo
[Adoptium]
name=Adoptium
baseurl=https://packages.adoptium.net/artifactory/rpm/fedora/\$releasever/\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.adoptium.net/artifactory/api/gpg/key/public
EOF

sudo dnf install temurin-21-jdk

curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install gradle
sdk install quarkus

# JetBrains

TBA_LINK=$(curl -fsSL "https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release" | jq -r '.TBA[0].downloads.linux.link')
wget -qO- "${TBA_LINK:?}" | sudo tar xvzC /opt
/opt/jetbrains-toolbox-*/bin/jetbrains-toolbox

# Kazam
sudo dnf install \
  python3-devel dbus-devel cairo-devel \
  gobject-introspection-devel \
  libgudev-devel keybinder3-devel \
  python3-gobject python3-gstreamer1 \
  xdotool cmake -y

pip install kazam

cat > ~/.local/share/applications/kazam.desktop <<EOF
[Desktop Entry]
Name=Kazam
Comment=Screen recording tool
Exec=kazam
Icon=kazam
Terminal=false
Type=Application
Categories=AudioVideo;Recorder;
StartupNotify=true
EOF

# PSEInt

curl -L "https://downloads.sourceforge.net/project/pseint/20230517/pseint-l64-20230517.tgz" | sudo tar xvzC /opt

# Rust

curl https://sh.rustup.rs -sSf | sh

# yt-dlp

pip install yt-dlp
pip install yq

# VirtualBox

sudo rpm --import https://www.virtualbox.org/download/oracle_vbox_2016.asc

curl -fsSL https://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo \
  | sudo tee /etc/yum.repos.d/virtualbox.repo > /dev/null

sudo dnf install -y VirtualBox-7.1

# ZSH

sudo dnf install -y zsh

sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

chsh -s $(which zsh)
