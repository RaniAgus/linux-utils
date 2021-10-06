sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

neofetch
cat /etc/upstream-release/lsb-release
DIST=$(cat /etc/upstream-release/lsb-release | grep "DISTRIB_CODENAME" | cut -d '=' -f2)
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(DIST) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker 
