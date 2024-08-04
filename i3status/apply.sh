#!/usr/bin/env bash

mkdir $HOME/.config/i3status/
cp ./config $HOME/.config/i3status

cat ./cronjob.template | crontab -

exit 0
