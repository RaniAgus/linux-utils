# fly.io
export FLYCTL_INSTALL="/home/agus/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

# nvm
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/.rbenv/shims:$PATH"
eval "$(rbenv init - zsh)"

# go
export PATH="$PATH:/usr/local/go/bin"

# utils
apt_install() {
  sudo apt-get update && sudo apt-get install -y "$@"
}

dpkg_install() {
  URL=${1:?}
  NAME=./$RANDOM.deb
  wget -O ${NAME} "${URL}"
  sudo apt install -y ${NAME}
  rm -v ${NAME}
}

gh_latest_tag() {
  curl -fsSL "https://api.github.com/repos/$1/releases/latest" | jq -r '.tag_name'
}

alias vm="valgrind --leak-check=full --track-origins=yes"
alias vh="valgrind --tool=helgrind"
alias vn="valgrind --tool=none"

alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=$(cat $HOME/.rangerdir); cd "$LASTDIR"'

alias ytdl-playlist='yt-dlp -o "%(playlist_index)s-%(title)s.%(ext)s"'
alias ytdl-video='yt-dlp -o "%(title)s.%(ext)s"'
alias ytdl-audio='yt-dlp -x -o "%(title)s.%(ext)s"'
