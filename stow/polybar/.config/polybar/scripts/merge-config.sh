#!/usr/bin/env bash

# =============================================================================
#
#   Polybar configuration merge script
#
#   Author:
#       - Piu Tranquillo (https://github.com/piutranq)
#
#   Concept:
#       - conf.d/ directory includes separated config files
#       - This script merges all config files to single config file, ./config
#
# =============================================================================

main() {
    # Merging order follows this array
    local -ar LIST_OF_PATH=(
        "header"
        "colors"
        "bar/top"
        "module/bspwm"
        "module/sxhkd"
        "module/wireless"
        "module/pulseaudio"
        "module/date"
        "module/battery"
        "module/dropbox"
        "module/mpd-nowplaying"
        "module/mpd-volume"
        "footer"
    )

    local POLYBAR="$HOME/.config/polybar"
    rm -rf "$POLYBAR/config"

    for elem in ${LIST_OF_PATH[*]}
    do
        local CPATH="$POLYBAR/conf.d/$elem"
        cat $CPATH >> "$POLYBAR/config"
        echo "" >> "$POLYBAR/config"
    done
    chmod -w "$POLYBAR/config"

}

main
