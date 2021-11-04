#!/bin/bash -x

# Ranger
pip install ranger-fm
sudo ln -s $HOME/.local/bin/ranger /usr/local/bin/ranger
sudo printf "\nalias ranger='ranger --choosedir=\$HOME/.rangerdir; LASTDIR=\$(cat \$HOME/.rangerdir); cd \"\$LASTDIR\"'\n\n" >> ~/.zshrc
# Shortcut: gnome-terminal -e "zsh -c '. ranger;zsh'"
