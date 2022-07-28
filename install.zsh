#!/bin/zsh

install() {
  sudo apt-get update && sudo apt-get install -y "$@"
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

# Node
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/$(gh_latest_tag nvm-sh/nvm)/install.sh | bash
cat ./aliases/nvm.sh >> ~/.zshrc
source ~/.zshrc
nvm install --lts

sudo ln -s "$(type -a nvm | awk '{ print $NF }')" "/usr/local/bin/nvm"
sudo ln -s "$(type -a node | awk '{ print $NF }')" "/usr/local/bin/node"
sudo ln -s "$(type -a npm | awk '{ print $NF }')" "/usr/local/bin/npm"

npm i --location=global degit @angular/cli

# Ruby
install libssl-dev
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
cat ./aliases/ruby.sh >> ~/.zshrc
source ~/.zshrc
rbenv install -l | grep -v "-" | tail -1 | xargs rbenv install

set -e

# Ranger
pip install ranger-fm
sudo ln -s $HOME/.local/bin/ranger /usr/local/bin/ranger
cat ./aliases/ranger.sh >> ~/.zshrc

# Valgrind aliases
echo 'alias memcheck="valgrind --leak-check=full --track-origins=yes"' >> ~/.zshrc
echo 'alias helgrind="valgrind --tool=helgrind"' >> ~/.zshrc

echo 'alias vg="memcheck"' >> ~/.zshrc
echo 'alias hg="helgrind"' >> ~/.zshrc

########################################################################################################################

sudo timedatectl set-local-rtc 1
echo "Remember to reboot! 'sudo shutdown -r 0'"
