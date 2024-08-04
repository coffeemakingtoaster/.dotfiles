#!/usr/bin/env bash

sudo apt-get install feh

sudo wget https://raw.githubusercontent.com/SammysHP/i3lockmore/master/i3lockmore -O /bin/i3lockmore
sudo chmod +x /bin/i3lockmore
sudo sed -ie 's@IMAGE=@IMAGE=~/.config/img/lockscreens/active.jpg@g' /bin/i3lockmore
sudo sed -ie 's@USE_IMAGE_FILL=false@USE_IMAGE_FILL=true@g' /bin/i3lockmore

sudo apt-get install imagemagick

mkdir $HOME/.config/i3/
cp ./config $HOME/.config/i3

exit 0
