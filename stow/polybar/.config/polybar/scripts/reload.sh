#!/usr/bin/env bash

# Reload sxhkd
[ -e '/usr/bin/sxhkd' ] && $XDG_CONFIG_HOME/sxhkd/scripts/launch.sh

# Merge config file
$XDG_CONFIG_HOME/polybar/scripts/merge-config.sh

# Launch bars
pkill -USR1 -x polybar &
