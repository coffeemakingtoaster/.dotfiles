#!/usr/bin/env bash

if [ "$(uname)" == "Darwin" ]; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
	sudo apt-get update && sudo apt-get install -y wget unzip

	# Prompt user to choose between i3 and sway
	read -p "Do you want to install i3? (y/n): " use_i3
	if [[ "$use_i3" =~ ^[Yy]$ ]]; then
		export USE_I3=1
		unset USE_SWAY
		echo "i3 selected. USE_I3=1"
	else
		read -p "Do you want to install sway? (y/n): " use_sway
		if [[ "$use_sway" =~ ^[Yy]$ ]]; then
			export USE_SWAY=1
			unset USE_I3
			echo "sway selected. USE_SWAY=1"
		else
			echo "Neither i3 nor sway selected. Exiting."
			exit 1
		fi
	fi
fi

function apply_conf () {
	cd ./"$1" || exit 1
	# Ensure environment variables are passed to subscripts
	USE_I3="$USE_I3" USE_SWAY="$USE_SWAY" ./apply.sh
	cd ..
}

directories=($(ls -l | grep '^d' | awk '{print $9}'))
for cmd in "${directories[@]}"; do
	echo "Applying config for $cmd..."
	apply_conf "$cmd"
done

