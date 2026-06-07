#!/usr/bin/env bash

if [ "$(uname)" == "Darwin" ]; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	exit 0
fi

sudo apt-get update && sudo apt-get install -y wget unzip

# Prompt user to choose a window manager (default: hyprland)
read -p "Which window manager? [hyprland/i3/sway] (default: hyprland): " wm_choice
wm_choice=${wm_choice:-hyprland}

case "$wm_choice" in
	hyprland|i3|sway)
		export WM="$wm_choice"
		echo "$wm_choice selected. WM=$wm_choice"
		;;
	*)
		echo "Unknown window manager: $wm_choice. Exiting."
		exit 1
		;;
esac

function apply_conf () {
	cd ./"$1" || exit 1
	# Ensure environment variables are passed to subscripts
	WM="$WM" ./apply.sh
	cd ..
}

directories=($(ls -l | grep '^d' | awk '{print $9}'))
for cmd in "${directories[@]}"; do
	# Skip the legacy/ directory — its configs are not auto-applied
	if [[ "$cmd" == "legacy" ]]; then
		continue
	fi
	echo "Applying config for $cmd..."
	apply_conf "$cmd"
done
