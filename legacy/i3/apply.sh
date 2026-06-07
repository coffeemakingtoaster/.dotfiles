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

sudo apt-get install -y feh imagemagick

sudo wget https://raw.githubusercontent.com/SammysHP/i3lockmore/master/i3lockmore -O /bin/i3lockmore
sudo chmod +x /bin/i3lockmore
sudo sed -ie 's@IMAGE=@IMAGE=~/.config/img/lockscreens/active.jpg@g' /bin/i3lockmore
sudo sed -ie 's@USE_IMAGE_FILL=false@USE_IMAGE_FILL=true@g' /bin/i3lockmore

mkdir $HOME/.config/i3/
cp ./config $HOME/.config/i3

i3-msg restart
