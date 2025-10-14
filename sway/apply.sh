#!/usr/bin/env bash

# Exit if USE_I3 is set
if [[ -n "$USE_I3" ]]; then
    echo "Warn: i3 environment detected (USE_I3 is set)."
    echo "This script is intended only for Sway installations."
    exit 0
fi

# Ensure USE_SWAY is set
if [[ -z "$USE_SWAY" ]]; then
    echo "Error: USE_SWAY is not set. Please run the setup script first."
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
