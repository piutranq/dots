#!/usr/bin/env bash

# Reload sxhkd
[ -e '/usr/bin/sxhkd' ] && $XDG_CONFIG_HOME/sxhkd/launch.sh

# Launch bars
pkill -USR1 -x polybar &
