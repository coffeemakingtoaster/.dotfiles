#!/usr/bin/env bash

if [ "$(uname)" == "Darwin" ]; then
	exit 1
fi

# albert install for debian 12
echo 'deb http://download.opensuse.org/repositories/home:/manuelschneid3r/Debian_12/ /' | sudo tee /etc/apt/sources.list.d/home:manuelschneid3r.list
curl -fsSL https://download.opensuse.org/repositories/home:manuelschneid3r/Debian_12/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_manuelschneid3r.gpg > /dev/null
sudo apt update -y
sudo apt install -y albert

mkdir -p ~/.config/albert
cp ./config ~/.config/albert/

# Do this for safety in case this runs AFTER sway setup
swaymsg reload

exit 0
