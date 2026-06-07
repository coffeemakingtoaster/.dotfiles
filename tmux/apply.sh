#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=../lib/log.sh
. "$(dirname "$0")/../lib/log.sh"
log_init

log_step "tmux" "installing tmux"
if [ "$(uname)" == "Darwin" ]; then
	brew install tmux
elif [ "${DISTRO:-}" = "fedora" ]; then
	sudo dnf install -y tmux
else
	sudo apt-get install -y tmux
fi

log_step "tmux" "copying config"
cp ./tmux.conf $HOME/.tmux.conf

log_info "remember to run prefix+I in tmux to install plugins"
