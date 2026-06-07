#!/usr/bin/env bash

if [ "$(uname)" == "Darwin" ]; then
	brew install fzf
elif [ "${DISTRO:-}" = "fedora" ]; then
	sudo dnf install -y fzf libnotify
else
	sudo apt install -y fzf libnotify-bin
fi

mkdir -p ~/.local/bin
cp ./tmux-sessionizer ~/.local/bin
cp ./tmux-sessionizer-base ~/.tmux-sessionizer

cp ./git-cloner ~/.local/bin
cp ./do-with-notify ~/.local/bin
