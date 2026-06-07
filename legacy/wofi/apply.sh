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

sudo apt-get install -y wofi

mkdir -p $HOME/.config/wofi/
cp ./style.css $HOME/.config/wofi
