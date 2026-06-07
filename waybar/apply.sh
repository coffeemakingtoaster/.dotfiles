#!/usr/bin/env bash

# Skip on macOS
if [ "$(uname)" == "Darwin" ]; then
	exit 0
fi

# Exit if WM is not hyprland
if [[ -n "$WM" && "$WM" != "hyprland" ]]; then
	echo "Warn: WM='$WM' detected."
	echo "This script is intended only for Hyprland installations."
	exit 0
fi

if [[ -z "$WM" ]]; then
	echo "Error: WM is not set. Please run the setup script first."
	exit 1
fi

mkdir -p ~/.config/waybar/
cp ./config.jsonc ./style.css ~/.config/waybar/

# Reload if already running
if pgrep -x waybar >/dev/null; then
	pkill -SIGUSR2 waybar
fi

exit 0
