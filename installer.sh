# Copy nvim config 
cp ./nvim ~/.config/nvim
# Install Oh my ZSH (requires curl)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Copy zsh files
cp .zshrc ~/.zshrc
# Source
source ~/.zshrc
