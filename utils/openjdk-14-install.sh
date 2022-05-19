#!/bin/bash

curl -O https://download.java.net/java/GA/jdk14/076bab302c7b4508975440c56f6cc26a/36/GPL/openjdk-14_linux-x64_bin.tar.gz
sudo mkdir /usr/lib/jvm/java-14-openjdk-amd64
sudo tar xvf openjdk-14_linux-x64_bin.tar.gz -C /usr/lib/jvm/java-14-openjdk-amd64 --strip-components=1
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-14-openjdk-amd64/bin/java 1
sudo update-alternatives --config java
rm openjdk-14_linux-x64_bin.tar.gz
