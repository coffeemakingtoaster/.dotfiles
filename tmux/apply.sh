#!/usr/bin/env bash

if [ "$(uname)" == "Darwin" ]; then
	brew install tmux
elif [ "${DISTRO:-}" = "fedora" ]; then
	sudo dnf install -y tmux
else
	sudo apt-get install -y tmux
fi

cp ./tmux.conf $HOME/.tmux.conf

echo remember to run leader+shift+i to install plugins

exit 0
