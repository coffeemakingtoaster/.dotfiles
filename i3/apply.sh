#!/usr/bin/env bash

sudo apt-get install -y feh imagemagick

sudo wget https://raw.githubusercontent.com/SammysHP/i3lockmore/master/i3lockmore -O /bin/i3lockmore
sudo chmod +x /bin/i3lockmore
sudo sed -ie 's@IMAGE=@IMAGE=~/.config/img/lockscreens/active.jpg@g' /bin/i3lockmore
sudo sed -ie 's@USE_IMAGE_FILL=false@USE_IMAGE_FILL=true@g' /bin/i3lockmore

mkdir $HOME/.config/i3/
cp ./config $HOME/.config/i3

i3-msg restart

exit 0
