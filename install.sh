#!/usr/bin/env bash

if [ "$(uname)" == "Darwin" ]; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	exit 0
fi

# Detect distro: Fedora-family uses dnf/rpm, others fall back to apt.
if command -v dnf >/dev/null 2>&1; then
	DISTRO="fedora"
	sudo dnf install -y wget unzip
else
	DISTRO="debian"
	sudo apt-get update && sudo apt-get install -y wget unzip
fi
export DISTRO

# Pick a window manager. Honor $WM env var for non-interactive runs,
# otherwise prompt with hyprland as the default.
if [[ -n "$WM" ]]; then
	wm_choice="$WM"
else
	read -p "Which window manager? [hyprland/i3/sway] (default: hyprland): " wm_choice
	wm_choice=${wm_choice:-hyprland}
fi

case "$wm_choice" in
	hyprland|i3|sway)
		export WM="$wm_choice"
		echo "$wm_choice selected. WM=$wm_choice (distro=$DISTRO)"
		;;
	*)
		echo "Unknown window manager: $wm_choice. Exiting."
		exit 1
		;;
esac

function apply_conf () {
	cd ./"$1" || exit 1
	# Ensure environment variables are passed to subscripts
	WM="$WM" DISTRO="$DISTRO" ./apply.sh
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
