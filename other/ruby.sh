#!/bin/bash

curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash

echo -e '\nexport PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
echo -e '\nexport PATH="$HOME/.rbenv/shims:$PATH"' >> ~/.zshrc
~/.rbenv/bin/rbenv init >> ~/.zshrc

# Instala la última versión estable de Ruby
~/.rbenv/bin/rbenv install -l | grep -v "-" | tail -1 | xargs ~/.rbenv/bin/rbenv install