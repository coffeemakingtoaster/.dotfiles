#!/usr/bin/env bash

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

if [ "$(uname)" == "Darwin" ]; then
	exit 0
fi

mkdir $HOME/.config/i3status/
cp ./config $HOME/.config/i3status

exit 0
