#!/usr/bin/env bash

sudo apt-get install -y rofi

mkdir $HOME/.config/rofi/
cp ./config.rasi $HOME/.config/rofi

exit 0
