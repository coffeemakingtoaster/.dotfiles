#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=../../lib/log.sh
. "$(dirname "$0")/../../lib/log.sh"
log_init

# Exit if WM is not i3
if [[ -n "${WM:-}" && "$WM" != "i3" ]]; then
	log_warn "WM='$WM' detected; this script is intended only for i3 installations, skipping"
	exit 0
fi

# Ensure WM is set
if [[ -z "${WM:-}" ]]; then
	log_err "WM is not set. Please run the setup script first."
	exit 1
fi

if [ "$(uname)" == "Darwin" ]; then
	exit 0
fi

mkdir $HOME/.config/i3status/
cp ./config $HOME/.config/i3status
