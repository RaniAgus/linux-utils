#!/bin/env bash

# Puppeteer
sudo apt update && sudo apt install -y libxkbcommon-dev libgbm-dev

cat ./.bashrc >> ~/.bashrc
cat ./.bashrc >> ~/.zshrc
