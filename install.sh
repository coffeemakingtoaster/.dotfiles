#!/usr/bin/env bash

sudo apt-get update

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
