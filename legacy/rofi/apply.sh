#!/usr/bin/env bash

if [ "$(uname)" == "Darwin" ]; then
	exit 0
fi

# Exit if WM is not i3
if [[ -n "$WM" && "$WM" != "i3" ]]; then
    echo "Warn: WM='$WM' detected."
    echo "This script is intended only for i3 installations."
    exit 0
fi

# Ensure WM is set
if [[ -z "$WM" ]]; then
    echo "Error: WM is not set. Please run the setup script first."
    exit 1
fi

sudo apt-get install -y rofi

mkdir $HOME/.config/rofi/
cp ./config.rasi $HOME/.config/rofi

exit 0
