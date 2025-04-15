#!/usr/bin/env bash

if [ "$(uname)" == "Darwin" ]; then
	exit 1
fi

# basic installs
sudo apt-get install -y sway wl-clipboard swaylock wdisplays swaybar

## build wofi from source

sudo apt-get install -y libwayland-dev libgtk-3-dev pkgconf meson
wget https://hg.sr.ht/~scoopta/wofi/archive/v1.4.1.tar.gz
tar -xvzf wofi-v1.4.1.tar.gz
# this is untested on a fresh system and may fail...oh well
(cd wofi && meson setup build && ninja -C build && sudo ninja -C build install)

mkdir -p ~/.config/sway/
cp ./config ./status.sh ./random-wallpaper.sh ~/.config/sway/
swaymsg reload

exit 0
