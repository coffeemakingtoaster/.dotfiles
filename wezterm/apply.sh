#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=../lib/log.sh
. "$(dirname "$0")/../lib/log.sh"
log_init

if [ "$(uname)" == "Darwin" ]; then
	# Darwin uses ghostty
	exit 0
fi

if [ "${DISTRO:-}" = "fedora" ]; then
	log_step "wezterm" "resolving latest wezterm .rpm from GitHub"
	# WezTerm publishes a portable Fedora rpm on every release; pick the
	# newest one from the GitHub releases API and hand it to dnf.
	latest_rpm_url=$(curl -fsSL https://api.github.com/repos/wez/wezterm/releases/latest \
		| grep -oE 'https://[^"]*\.rpm"' \
		| head -n 1 \
		| tr -d '"')
	if [ -z "$latest_rpm_url" ]; then
		log_err "could not determine the latest wezterm .rpm URL"
		exit 1
	fi
	log_info "installing $latest_rpm_url"
	sudo dnf install -y "$latest_rpm_url"
else
	log_step "wezterm" "installing from apt.fury.io"
	curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
	echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
	sudo apt update
	sudo apt install wezterm
fi

log_step "wezterm" "copying config"
cp -r wezterm $HOME/.config

log_step "wezterm" "installing Fixedsys Core font"
mkdir -p ~/.fonts
wget -O ~/.fonts/FixedsysCore-Regular.ttf https://github.com/delinx/Fixedsys-Core/raw/refs/heads/main/FixedsysCore-Regular.ttf
fc-cache -fv
