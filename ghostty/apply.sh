#!/usr/bin/env bash
if [ "$(uname)" == "Darwin" ]; then
	brew install --cask ghostty 
else

	if type snap >/dev/null 2>&1; then
		sudo snap install ghostty --classic
	fi
fi

cp -r ghostty $HOME/.config

# This should (tm) ensure that the application support folder has been created
# If that is not the case execute the rm command below again after starting ghostty for the first time 
if type ghostty >/dev/null 2>&1; then
	ghostty +show-config
fi

rm -rf ~/Library/Application Support/com.mitchellh.ghostty/

exit 0
