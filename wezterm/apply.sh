#!/usr/bin/env bash
if [ "$(uname)" == "Darwin" ]; then
	brew install --cask wezterm
else
	curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
	echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
	sudo apt update
	sudo apt install wezterm
fi

cp -r ./wezterm/ $HOME/.config

exit 0
