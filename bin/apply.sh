#!/usr/bin/env bash

if [ "$(uname)" == "Darwin" ]; then
	brew install fzf
else
	sudo apt install fzf
fi

cp ./tmux-sessionizer ~/.local/bin
cp ./tmux-sessionizer-base ~/.tmux-sessionizer
