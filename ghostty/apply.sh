#!/usr/bin/env bash
if [ "$(uname)" == "Darwin" ]; then
	brew install --cask ghostty 
else
	exit 0
fi

cp -r ghostty $HOME/.config

# This should (tm) ensure that the application support folder has been created
# If that is not the case execute the rm command below again after starting ghostty for the first time 
ghostty +show-config

rm -rf ~/Library/Application Support/com.mitchellh.ghostty/

exit 0
