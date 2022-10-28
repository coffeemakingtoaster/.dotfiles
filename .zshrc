
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export XDG_CONFIG_HOME="$HOME/.config"

ZSH_THEME="bureau"



COMPLETION_WAITING_DOTS="true"



plugins=(git docker node python)
source $ZSH/oh-my-zsh.sh

if type "xrandr" > /dev/null; then
# Rotate screen and their position for home setup
xrandr --output HDMI-A-1 --rotate left --pos 0x0 --output DisplayPort-0 --pos 1080x1920 
fi

if type "feh" > /dev/null; then
# Set background for new workspaces
feh --bg-fill --no-xinerama /home/max/Pictures/Wallpapers/active/wallpaper.jpg
fi

# Start shell directly in tmux
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
	tmux
	# Check if tmux windows have already been opened. If so -> skip
	window_count=$(tmux list-windows | wc -l)
	if (($window_count == 1 )); then
		tmux new-window -n "vim"\; new-window -n "runtime"\; attach 
	fi
fi
