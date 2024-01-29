#!/bin/zsh

apt_install() {
  sudo apt-get update && sudo apt-get install -y "$@"
}

gh_latest_tag() {
  curl -fsSL "https://api.github.com/repos/$1/releases/latest" | jq -r '.tag_name' | sed 's/v//g'
}

# bun
curl -fsSL https://bun.sh/install | bash

# nvm
wget -qO- "https://raw.githubusercontent.com/nvm-sh/nvm/v$(gh_latest_tag nvm-sh/nvm)/install.sh" | bash

# rbenv
apt_install libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash

# Install aliases
cat ./dotfiles/.zshrc >> ~/.zshrc
# shellcheck disable=SC1090,SC3046
source ~/.zshrc

# Go
go install github.com/go-task/task/v3/cmd/task@latest
go install github.com/spf13/cobra-cli@latest
go install github.com/sqlc-dev/sqlc/cmd/sqlc@latest
go install github.com/pressly/goose/v3/cmd/goose@latest
go install github.com/a-h/templ/cmd/templ@latest
go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2
go install github.com/fullstorydev/grpcui/cmd/grpcui@latest
go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest

# Node.js
nvm install --lts
npm i --location=global npm@latest @angular/cli degit http-server tldr typescript yarn
curl -fsSL https://get.pnpm.io/install.sh | sh -
curl -fsSL https://dprint.dev/install.sh | sh

# Plugins
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

# Ruby
rbenv install -l 2> /dev/null | grep '^3' | tail -1 | xargs rbenv install
rbenv versions | xargs rbenv global
gem install pry bundler rspec colorize rails jekyll

########################################################################################################################

# Dual boot timezone fix
# sudo timedatectl set-local-rtc 1
echo "Remember to reboot! 'sudo shutdown -r 0'"
