#!/usr/bin/env bash

if [ "$(uname)" == "Darwin" ]; then
	brew install fzf
else
	sudo apt install fzf
fi

mkdir -p ~/.local/bin
cp ./tmux-sessionizer ~/.local/bin
cp ./tmux-sessionizer-base ~/.tmux-sessionizer

cp ./git-cloner ~/.local/bin
cp ./do-with-notify ~/.local/bin
