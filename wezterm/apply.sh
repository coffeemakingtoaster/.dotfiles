#!/usr/bin/env bash
if [ "$(uname)" == "Darwin" ]; then
	# Darwin uses ghostty
	exit 0
fi

if [ "${DISTRO:-}" = "fedora" ]; then
	# Install the latest WezTerm .rpm release from GitHub.
	# WezTerm publishes a portable Fedora rpm on every release, so we just
	# pick up the most recent one and hand it to dnf.
	latest_rpm_url=$(curl -fsSL https://api.github.com/repos/wez/wezterm/releases/latest \
		| grep -oE 'https://[^"]*\.rpm"' \
		| head -n 1 \
		| tr -d '"')
	if [ -z "$latest_rpm_url" ]; then
		echo "Could not determine the latest wezterm .rpm URL. Aborting."
		exit 1
	fi
	sudo dnf install -y "$latest_rpm_url"
else
	curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
	echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
	sudo apt update
	sudo apt install wezterm
fi

cp -r wezterm $HOME/.config

# install font

mkdir -p ~/.fonts
wget -O ~/.fonts/FixedsysCore-Regular.ttf https://github.com/delinx/Fixedsys-Core/raw/refs/heads/main/FixedsysCore-Regular.ttf
fc-cache -fv

exit 0
