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

# Enable Hyprland COPR (idempotent)
if ! dnf copr list-enabled 2>/dev/null | grep -q "^lionheartp/Hyprland"; then
	sudo dnf copr enable -y lionheartp/Hyprland
fi

# Install hyprland and related core packages
sudo dnf install -y \
	hyprland hyprlock hyprpaper \
	wl-clipboard grim slurp \
	pipewire wireplumber \
	ghostty \
	pavucontrol \
	waybar

# Enable Walker COPR (idempotent) and install walker + elephant
if ! dnf copr list-enabled 2>/dev/null | grep -q "^errornointernet/walker"; then
	sudo dnf copr enable -y errornointernet/walker
fi
sudo dnf install -y walker elephant

# Enable Elephant as a user service if not already running
if ! systemctl --user is-active elephant.service >/dev/null 2>&1; then
	elephant service enable
	systemctl --user start elephant.service
fi

mkdir -p ~/.config/hypr/
cp ./hyprland.conf ./hyprlock.conf ./hyprpaper.conf ~/.config/hypr/

# Reload if already running
if pgrep -x Hyprland >/dev/null; then
	hyprctl reload
fi

exit 0
