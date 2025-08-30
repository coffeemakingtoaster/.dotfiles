#!/usr/bin/env bash

if [ "$(uname)" == "Darwin" ]; then
	exit 1
fi

sudo apt-get install -y wofi

mkdir -p $HOME/.config/wofi/
cp ./style.css $HOME/.config/wofi

exit 0
