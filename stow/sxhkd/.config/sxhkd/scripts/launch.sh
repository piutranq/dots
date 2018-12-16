#!/usr/bin/env bash

# Alias
FIFO_PATH="$HOME/.cache/sxhkd.fifo"

# Kill sxhkd
killall -q sxhkd
while pgrep -u $UID -x sxhkd >/dev/null; do sleep 1; done;

# Reset fifo
[ -e "$FIFO_PATH" ] && rm "$FIFO_PATH"
mkfifo "$FIFO_PATH"

# Launch sxhkd
sxhkd -s "$FIFO_PATH" &
