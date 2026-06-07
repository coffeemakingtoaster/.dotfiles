#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=../lib/log.sh
. "$(dirname "$0")/../lib/log.sh"
log_init

log_step "bin" "installing fzf and notification tools"
if [ "$(uname)" == "Darwin" ]; then
	brew install fzf
elif [ "${DISTRO:-}" = "fedora" ]; then
	sudo dnf install -y fzf libnotify
else
	sudo apt install -y fzf libnotify-bin
fi

log_step "bin" "installing helper scripts"
mkdir -p ~/.local/bin
cp ./tmux-sessionizer ~/.local/bin
cp ./tmux-sessionizer-base ~/.tmux-sessionizer

cp ./git-cloner ~/.local/bin
cp ./do-with-notify ~/.local/bin

log_info "bin helpers installed"
