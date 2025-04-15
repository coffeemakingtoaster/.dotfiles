#!/bin/bash
WALLPAPER=$(find ~/.config/img/wallpapers/ -type f | shuf -n 1)
for output in $(swaymsg -t get_outputs | jq -r '.[].name'); do
    swaymsg output "$output" bg "$WALLPAPER" fill
done

