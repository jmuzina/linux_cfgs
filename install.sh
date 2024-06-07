#!/bin/bash

set -e

ARCH="amd64"

cd ~
rm -rf ./bootstrap
mkdir bootstrap
cd bootstrap

sudo apt-get update && sudo apt-get upgrade -y

sudo apt-get install -y \
    fuse \
    gcc \
    wget \
    guake \
    emacs \
    snapd \
    flatpak \
    vim

# Displaylink
wget https://www.synaptics.com/sites/default/files/Ubuntu/pool/stable/main/all/synaptics-repository-keyring.deb
sudo apt install -y ./synaptics-repository-keyring.deb
sudo apt update
sudo apt install -y displaylink-driver
rm ./synaptics-repository-keyring.deb

# Jetbrains
toolbox_version="2.3.2.31487"
toolbox_file_name="jetbrains-toolbox-$toolbox_version.tar.gz"
wget "https://download.jetbrains.com/toolbox/$toolbox_file_name"
tar -xzf ./"$toolbox_file_name"
chmod +x "./$toolbox_file_name"
./"jetbrains-toolbox-$toolbox_version/jetbrains-toolbox"
rm -rf ./"$toolbox_file_name" ./"jetbrains-toolbox-$toolbox_version/"

# Docker
docker_desktop_version="4.30.0"
echo "Installing Docker Desktop $docker_desktop_version..."

for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
    sudo apt-get remove -y $pkg
done

sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo usermod -aG docker $USER

wget "https://desktop.docker.com/linux/main/amd64/149282/docker-desktop-$docker_desktop_version-amd64.deb"

sudo apt install -y ./"docker-desktop-$docker_desktop_version-amd64.deb"
rm ./"docker-desktop-$docker_desktop_version-amd64.deb"

grep "$USER" /etc/subuid >> /dev/null 2&>1 || (echo "$USER:100000:65536" | sudo tee -a /etc/subuid)
grep "$USER" /etc/subgid >> /dev/null 2&>1 || (echo "$USER:100000:65536" | sudo tee -a /etc/subgid)

# Spotify
curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install -y spotify-client

# Various snaps
sudo snap install discord
sudo snap install --classic code
sudo snap install --classic gitkraken

# Betterbird
 sudo add-apt-repository ppa:flatpak/stable
 sudo apt update
 sudo apt install -y flatpak

# Clockify
wget https://clockify.me/downloads/Clockify_Setup_x64.deb
sudo apt install -y ./Clockify_Setup_x64.deb
rm ./Clockify_Setup_x64.deb

# Codium
codium_version="1.89.1.24130"
wget "https://github.com/VSCodium/vscodium/releases/download/$codium_version/codium_$(echo $codium_version)_$ARCH.deb"
sudo apt install -y "./codium_$(echo $codium_version)_$ARCH.deb"
rm "./codium_$(echo $codium_version)_$ARCH.deb"

# Steam 
wget https://cdn.akamai.steamstatic.com/client/installer/steam.deb
sudo apt install -y ./steam.deb
rm ./steam.deb

# Python
sudo apt-get install -y python3-pip
pip3 install requests==2.31.0
sudo pip3 install dotrun

# Node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install 20

npm i -g yarn

guake & newgrp docker &

