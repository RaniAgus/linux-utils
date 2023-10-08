#!/bin/zsh

apt_install() {
  sudo apt-get update && sudo apt-get install -y "$@"
}

gh_latest_tag() {
  curl -fsSL "https://api.github.com/repos/$1/releases/latest" | jq -r '.tag_name'
}

# nvm
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/$(gh_latest_tag nvm-sh/nvm)/install.sh | bash

# rbenv
apt_install libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash

# Install aliases
cat ./dotfiles/.zshrc >> ~/.zshrc
source ~/.zshrc

# Node.js
nvm install --lts
npm i --location=global npm@latest @angular/cli degit http-server pnpm tldr typescript yarn

# Plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Ruby
rbenv install $(rbenv install -l 2> /dev/null | grep -v "-" | tail -1)
rbenv global $(rbenv versions)
gem install pry bundler rspec colorize rails jekyll

########################################################################################################################

# Dual boot timezone fix
# sudo timedatectl set-local-rtc 1
echo "Remember to reboot! 'sudo shutdown -r 0'"
