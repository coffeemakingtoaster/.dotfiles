#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=../lib/log.sh
. "$(dirname "$0")/../lib/log.sh"
log_init

if [ "$(uname)" == "Darwin" ]; then
	log_step "ghostty" "installing via brew cask"
	brew install --cask ghostty
	exit 0
fi

if [ "${DISTRO:-}" = "fedora" ]; then
	log_step "ghostty" "installing via dnf"
	sudo dnf install -y ghostty
else
	log_step "ghostty" "installing via snap (if available)"
	if type snap >/dev/null 2>&1; then
		sudo snap install ghostty --classic
	else
		log_warn "snap not present; ghostty install skipped"
	fi
fi

log_step "ghostty" "copying config"
cp -r ghostty $HOME/.config

# This should (tm) ensure that the application support folder has been created
# If that is not the case execute the rm command below again after starting ghostty for the first time
if type ghostty >/dev/null 2>&1; then
	ghostty +show-config >/dev/null || true
fi

rm -rf ~/Library/Application\ Support/com.mitchellh.ghostty/
