#!/usr/bin/env bash

pkill -USR1 -x sxhkd && \
notify-send --app-name=sxhkd --urgency=normal "sxhkd has reloaded"
