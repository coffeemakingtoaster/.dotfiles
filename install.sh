#!/usr/bin/env bash

if [ "$(uname)" == "Darwin" ]; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
	sudo apt-get update
fi


function apply_conf () {
	cd ./$1
	./apply.sh
	cd ..
}

directories=(`ls -l | grep '^d' | awk '{print $9}'`)
for cmd in "${directories[@]}"; do
	echo apply config for $cmd...
	apply_conf $cmd
done
