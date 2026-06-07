#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=../lib/log.sh
. "$(dirname "$0")/../lib/log.sh"
log_init

if [ "$(uname)" == "Darwin" ]; then
	log_step "nvim" "installing nvim via homebrew"
	brew install nvim
else
	log_step "nvim" "installing build prerequisites"
	if [ "${DISTRO:-}" = "fedora" ]; then
		sudo dnf install -y make gcc ripgrep unzip git curl wl-clipboard
	else
		sudo apt install -y make gcc ripgrep unzip git xclip curl git
	fi

	log_step "nvim" "downloading nvim release tarball"
	# We use the upstream binary tarball because the apt version is too old.
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
	# legacy location
	sudo rm -rf /opt/nvim-linux64
	# new location
	sudo rm -rf /opt/nvim-linux-x86_64
	sudo mkdir -p /opt/nvim-linux-x86_64
	sudo chmod a+rX /opt/nvim-linux-x86_64
	sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

	sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/

	rm nvim-linux*
fi

log_step "nvim" "resetting existing nvim state"
rm -rf ~/.local/share/nvim/

log_step "nvim" "cloning kickstart.nvim"
git clone --quiet https://github.com/coffeemakingtoaster/kickstart.nvim.git $HOME/.config/nvim
