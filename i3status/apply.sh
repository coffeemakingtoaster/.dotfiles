#!/usr/bin/env bash

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

if [ "$(uname)" == "Darwin" ]; then
	exit 0
fi

mkdir $HOME/.config/i3status/
cp ./config $HOME/.config/i3status

exit 0
