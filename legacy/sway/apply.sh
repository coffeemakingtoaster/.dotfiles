#!/usr/bin/env bash

# Exit if WM is not sway
if [[ -n "$WM" && "$WM" != "sway" ]]; then
    echo "Warn: WM='$WM' detected."
    echo "This script is intended only for Sway installations."
    exit 0
fi

# Ensure WM is set
if [[ -z "$WM" ]]; then
    echo "Error: WM is not set. Please run the setup script first."
    exit 1
fi

if [ "$(uname)" == "Darwin" ]; then
	exit 1
fi

# basic installs
sudo apt-get install -y sway wl-clipboard swaylock wdisplays slurp pavucontrol grim

mkdir -p ~/.config/sway/
cp ./config ./status.sh ./random-wallpaper.sh ~/.config/sway/
swaymsg reload

exit 0
