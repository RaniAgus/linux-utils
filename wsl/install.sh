#!/bin/env bash

# Puppeteer
sudo apt update && sudo apt install -y libxkbcommon-dev libgbm-dev

cat ./.bashrc >> ~/.bashrc
cat ./.bashrc >> ~/.zshrc

# Git credential helper: https://github.com/git-ecosystem/git-credential-manager/blob/main/docs/wsl.md
#  git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"

# wslu
sudo add-apt-repository ppa:wslutilities/wslu
sudo apt update && sudo apt install wslu
