#!/usr/bin/env bash

if [ "$(uname)" == "Darwin" ]; then
	exit 0
fi

# Exit if USE_SWAY is set
if [[ -n "$USE_SWAY" ]]; then
    echo "Warn: Sway environment detected (USE_SWAY is set)."
    echo "This script is intended only for i3 installations."
    exit 0
fi

# Ensure USE_I3 is set
if [[ -z "$USE_I3" ]]; then
    echo "Error: USE_I3 is not set. Please run the setup script first."
    exit 1
fi

sudo apt-get install -y rofi

mkdir $HOME/.config/rofi/
cp ./config.rasi $HOME/.config/rofi

exit 0
