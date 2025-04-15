#!/usr/bin/env bash

# disabled due to migration to sway -> kept for legacy purposes
exit 0

mkdir $HOME/.config/i3status/
cp ./config $HOME/.config/i3status

cat ./cronjob.template | crontab -

exit 0
