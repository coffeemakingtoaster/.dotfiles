#!/usr/bin/env bash

## Check if the -f flag is present
if [ "$1" == "-f" ]; then
	export IGNORE_DOTFILES_CHECK=1
else
	export IGNORE_DOTFILES_CHECK=0
fi

if [ $IGNORE_DOTFILES_CHECK -eq 0 ]; then
	## Check if the script is being called from the correct directory
	#
	if [ ! -d "./.git" ]; then
		echo "ERROR: Not inside a git repository"
		exit 1
	fi
	#
	if [[ "`git rev-parse --show-toplevel`" != *".dotfiles" ]]; then
		echo "ERROR: Not inside the correct git repository"
		exit 1
	fi
	#
	if [[ "`git rev-parse --show-toplevel`" != "`pwd`" ]]; then
		echo "ERROR: install.sh not called inside the git repository"
		exit 1
	fi
fi

function apply_conf () {
	if [command -v $1 &>/dev/null || $IGNORE_DOTFILES_CHECK == 1] then
		positive $1
		cd $HOME/.dotfiles/$1
		./apply.sh || negative $1
		cd ..
	fi
}

directories=(`ls -l | grep '^d' | awk '{print $9}'`)
for cmd in "${directories[@]}"; do
	echo apply config for $cmd...
	apply_conf $cmd
done
