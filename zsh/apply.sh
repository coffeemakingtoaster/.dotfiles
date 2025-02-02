#!/usr/bin/env bash

if [ "$(uname)" == "Darwin" ]; then
	# zsh is default on osx
	echo "zsh already present"
else
	sudo apt-get install -y zsh
	chsh -s $(which zsh)
fi

# omz
if [ ! -d $HOME/.oh-my-zsh ]; then
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

cp ./zshrc $HOME/.zshrc

exit 0
