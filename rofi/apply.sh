#!/usr/bin/env bash

# disabled due to migration to sway -> kept for legacy purposes
exit 0

if [ "$(uname)" == "Darwin" ]; then
	exit 1
fi

sudo apt-get install -y rofi

mkdir $HOME/.config/rofi/
cp ./config.rasi $HOME/.config/rofi

exit 0
