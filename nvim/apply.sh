#!/usr/bin/env bash

if [ "$(uname)" == "Darwin" ]; then
	echo "Install neovim (homebrew)"
	brew install nvim
else
	echo "Install neovim (no package manager) and needed packages for kickstart (via apt)"

	sudo apt install -y make gcc ripgrep unzip git xclip curl git
	# Now we install nvim
	# I use debian and the apt version is too far behind
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
	sudo rm -rf /opt/nvim-linux64
	sudo mkdir -p /opt/nvim-linux64
	sudo chmod a+rX /opt/nvim-linux64
	sudo tar -C /opt -xzf nvim-linux64.tar.gz

	sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/

fi

# Cleanup
rm -rf ~/.local/share/nvim/

git clone --quiet https://github.com/coffeemakingtoaster/kickstart.nvim.git $HOME/.config/nvim

exit 0
