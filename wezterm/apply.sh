#!/usr/bin/env bash
if [ "$(uname)" == "Darwin" ]; then
	# Darwin uses ghostty
	exit 0
fi

# TODO: Once a linux package is published also port this
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo apt update
sudo apt install wezterm

cp -r wezterm $HOME/.config

# install font

mkdir -p ~/.fonts
wget -O ~/.fonts/FixedsysCore-Regular.ttf https://github.com/delinx/Fixedsys-Core/raw/refs/heads/main/FixedsysCore-Regular.ttf
fc-cache -fv

exit 0
