# Ranger
pip install ranger-fm
sudo ln -s $HOME/.local/bin/ranger /usr/local/bin/ranger
sudo printf "\nalias ranger='ranger --choosedir=\$HOME/.rangerdir; LASTDIR=\$(cat \$HOME/.rangerdir); cd \"\$LASTDIR\"'\n\n" >> ~/.zshrc
# Shortcut: gnome-terminal -e "zsh -c '. ranger;zsh'"

# Node JS (chequear última versión de nvm)
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
sudo printf '\nexport NVM_DIR="$HOME/.nvm"\n[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm\n\n' >> ~/.zshrc
source ~/.zshrc
nvm install --lts

# Java
sudo update-alternatives --config java # Switch to Java 8
