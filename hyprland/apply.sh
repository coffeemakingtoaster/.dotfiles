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

# Enable Hyprland COPR (idempotent)
if ! dnf copr list-enabled 2>/dev/null | grep -q "^lionheartp/Hyprland"; then
	log_step "hyprland" "enabling lionheartp/Hyprland COPR"
	sudo dnf copr enable -y lionheartp/Hyprland
fi

log_step "hyprland" "installing hyprland and core packages"
# ghostty is intentionally not in this list. It is a separate module
# (ghostty/apply.sh) and may be in default Fedora repos or a COPR
# depending on the release.
sudo dnf install -y \
	hyprland hyprlock hyprpaper \
	wl-clipboard grim slurp \
	pipewire wireplumber \
	pavucontrol \
	waybar

# Enable Walker COPR (idempotent) and install walker + elephant
if ! dnf copr list-enabled 2>/dev/null | grep -q "^errornointernet/walker"; then
	log_step "hyprland" "enabling errornointernet/walker COPR"
	sudo dnf copr enable -y errornointernet/walker
fi
log_step "hyprland" "installing walker and elephant"
sudo dnf install -y walker elephant

# Enable Elephant as a user service if not already running.
# Skipped in environments without systemd (containers, headless installs).
if [[ -n "${DOTFILES_SKIP_SYSTEMD:-}" ]]; then
	log_info "elephant service setup skipped (DOTFILES_SKIP_SYSTEMD is set)"
elif ! systemctl --user is-active elephant.service >/dev/null 2>&1; then
	log_step "hyprland" "enabling elephant user service"
	elephant service enable
	systemctl --user start elephant.service
fi

log_step "hyprland" "copying configs"
mkdir -p ~/.config/hypr/
cp ./hyprland.conf ./hyprlock.conf ./hyprpaper.conf ~/.config/hypr/

# Reload if already running
if pgrep -x Hyprland >/dev/null; then
	log_info "reloading running Hyprland instance"
	hyprctl reload
fi
