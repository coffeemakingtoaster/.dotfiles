#!/usr/bin/env bash

echo "Install neovim (no package manager) and needed packages for kickstart (via apt)"

sudo apt install -y make gcc ripgrep unzip git xclip curl git

# Now we install nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim-linux64
sudo mkdir -p /opt/nvim-linux64
sudo chmod a+rX /opt/nvim-linux64
sudo tar -C /opt -xzf nvim-linux64.tar.gz

sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/

git clone --quiet https://github.com/coffeemakingtoaster/kickstart.nvim.git $HOME/.config/nvim

exit 0
