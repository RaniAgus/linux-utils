# go
export PATH="$PATH:/usr/local/go/bin:$HOME/go/bin"

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

# Rust
. "$HOME/.cargo/env"

# sdkman
source "$HOME/.sdkman/bin/sdkman-init.sh"

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
  curl -fsSL "https://api.github.com/repos/$1/releases/latest" | jq -r '.tag_name' | sed 's/v//g'
}

# valgrind
alias vm="valgrind --leak-check=full --track-origins=yes"
alias vh="valgrind --tool=helgrind"
alias vn="valgrind --tool=none"

# ranger
rcd () {
  ranger --choosedir="$HOME/.rangerdir"
  cd "$(cat "$HOME/.rangerdir")" || exit
}
bindkey -s '^o' 'rcd\n'

# ytdl
alias ytdl-playlist='yt-dlp -o "%(playlist_index)s-%(title)s.%(ext)s"'
alias ytdl-video='yt-dlp -o "%(title)s.%(ext)s"'
alias ytdl-audio='yt-dlp -x -o "%(title)s.%(ext)s"'

# video durations
ffprobe-duration() {
  files="${1:=$(ls)}"
  durations=$(\
    echo "$files" \
    | xargs -I{} ffprobe -show_format "{}" 2> /dev/null \
    | grep duration \
    | cut -d'=' -f2 \
    | xargs -I{} date -d@{} -u +%H:%M:%S \
  )
  paste <(echo "$durations") <(echo "$files")
}

# zoxide
eval "$(zoxide init --cmd cd zsh)"

