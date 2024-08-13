#!/usr/bin/env bash

sudo apt-get install -y tmux 

cp ./tmux.conf $HOME/.tmux.conf

echo remember to run leader+shift+i to install plugins

exit 0
