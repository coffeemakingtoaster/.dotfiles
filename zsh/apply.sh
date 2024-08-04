#!/usr/bin/env bash

# omz
if [ ! -d $HOME/.oh-my-zsh ]; then
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

cp ./zshrc $HOME/.zshrc

exit 0
