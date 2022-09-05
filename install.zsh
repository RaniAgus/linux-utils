#!/bin/zsh

install() {
  sudo apt-get update && sudo apt-get install -y "$@"
}

gh_latest_tag() {
  curl -fsSL "https://api.github.com/repos/$1/releases/latest" | jq -r '.tag_name'
}

# nvm
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/$(gh_latest_tag nvm-sh/nvm)/install.sh | bash

# rbenv
install libssl-dev
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash

# Install aliases
cat ./aliases/.zshrc >> ~/.zshrc
source ~/.zshrc

# Node.js
nvm install --lts
npm i --location=global degit yarn @angular/cli

# Ruby
rbenv install $(rbenv install -l 2> /dev/null | grep -v "-" | tail -1)
rbenv global $(rbenv versions)
gem install pry bundler

# Ranger
pip install ranger-fm
sudo ln -s $HOME/.local/bin/ranger /usr/local/bin/ranger

########################################################################################################################

# Dual boot timezone fix
# sudo timedatectl set-local-rtc 1
echo "Remember to reboot! 'sudo shutdown -r 0'"
