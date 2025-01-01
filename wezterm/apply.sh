#!/usr/bin/env bash
if [ "$(uname)" == "Darwin" ]; then
	# Darwin uses ghostty
	exit 0
else
	# TODO: Once a linux package is published also port this
	curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
	echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
	sudo apt update
	sudo apt install wezterm
fi

cp -r wezterm $HOME/.config

exit 0
