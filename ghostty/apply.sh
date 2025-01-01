#!/usr/bin/env bash
if [ "$(uname)" == "Darwin" ]; then
	brew install --cask ghostty 
else
	exit 0
fi

cp -r ghostty $HOME/.config

exit 0
