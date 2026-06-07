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

sudo apt-get install -y wofi

mkdir -p $HOME/.config/wofi/
cp ./style.css $HOME/.config/wofi

exit 0
