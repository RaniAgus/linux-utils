#!/bin/zsh -x

source ./utils/functions.sh

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
install libssl-dev
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
cat ./aliases/ruby.sh >> ~/.zshrc
source ~/.zshrc
rbenv install -l | grep -v "-" | tail -1 | xargs rbenv install

########################################################################################################################

sudo timedatectl set-local-rtc 1
echo "Remember to reboot! 'sudo shutdown -r 0'"
