install() {
  sudo apt update && sudo apt install -y "$@"
}

remove() {
  rm -rfv "$@"
}

install_dpkg() {
  URL=${1:?}
  NAME=$(tempfile -s .deb)
  wget -O ${NAME} "${URL}"
  sudo apt install ${NAME}
  remove ${NAME}
}

gh_latest_tag() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}
