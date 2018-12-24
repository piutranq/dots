#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar &> /dev/null 2>&1

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Merge config file
$XDG_CONFIG_HOME/polybar/scripts/merge-config.sh

# Launch bars
polybar top &> /dev/null 2>&1 &
