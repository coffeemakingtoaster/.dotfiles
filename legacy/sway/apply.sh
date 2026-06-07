#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=../../lib/log.sh
. "$(dirname "$0")/../../lib/log.sh"
log_init

# Exit if WM is not sway
if [[ -n "${WM:-}" && "$WM" != "sway" ]]; then
	log_warn "WM='$WM' detected; this script is intended only for Sway installations, skipping"
	exit 0
fi

# Ensure WM is set
if [[ -z "${WM:-}" ]]; then
	log_err "WM is not set. Please run the setup script first."
	exit 1
fi

if [ "$(uname)" == "Darwin" ]; then
	exit 1
fi

# basic installs
sudo apt-get install -y sway wl-clipboard swaylock wdisplays slurp pavucontrol grim

mkdir -p ~/.config/sway/
cp ./config ./status.sh ./random-wallpaper.sh ~/.config/sway/
swaymsg reload
