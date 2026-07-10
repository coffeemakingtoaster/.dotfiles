#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=../lib/log.sh
. "$(dirname "$0")/../lib/log.sh"
log_init

# Skip on macOS
if [ "$(uname)" == "Darwin" ]; then
	exit 0
fi

# Exit if WM is not hyprland
if [[ -n "${WM:-}" && "$WM" != "hyprland" ]]; then
	log_warn "WM='$WM' detected; this script is intended only for Hyprland installations, skipping"
	exit 0
fi

if [[ -z "${WM:-}" ]]; then
	log_err "WM is not set. Please run the setup script first."
	exit 1
fi

log_step "mako" "installing mako"
sudo dnf install -y mako	

log_step "mako" "copying configs"
mkdir -p ~/.config/mako/
cp ./config ~/.config/mako/

# Reload if already running
if pgrep -x Hyprland >/dev/null; then
	log_info "reloading running Hyprland instance"
	hyprctl reload
fi
