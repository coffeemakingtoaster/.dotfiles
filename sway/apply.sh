#!/usr/bin/env bash

if [ "$(uname)" == "Darwin" ]; then
	exit 1
fi

# basic installs
sudo apt-get install -y sway wl-clipboard swaylock wdisplays slurp pavucontrol

mkdir -p ~/.config/sway/
cp ./config ./status.sh ./random-wallpaper.sh ~/.config/sway/
swaymsg reload

exit 0
