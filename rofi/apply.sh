#!/usr/bin/env bash

if [ "$(uname)" == "Darwin" ]; then
	exit 1
fi

sudo apt-get install -y rofi

mkdir $HOME/.config/rofi/
cp ./config.rasi $HOME/.config/rofi

exit 0
