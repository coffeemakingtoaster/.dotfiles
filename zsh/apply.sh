#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=../lib/log.sh
. "$(dirname "$0")/../lib/log.sh"
log_init

log_step "zsh" "installing zsh"
if [ "$(uname)" == "Darwin" ]; then
	log_info "zsh is the default shell on macOS, skipping install"
elif [ "${DISTRO:-}" = "fedora" ]; then
	sudo dnf install -y zsh
	sudo chsh -s "$(which zsh)" "${USER:-$(id -un)}"
else
	sudo apt-get install -y zsh
	sudo chsh -s "$(which zsh)" "${USER:-$(id -un)}"
fi

log_step "zsh" "installing oh-my-zsh"
if [ ! -d $HOME/.oh-my-zsh ]; then
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

log_step "zsh" "copying zshrc"
cp ./zshrc $HOME/.zshrc
