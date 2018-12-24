#!/usr/bin/env bash

# Configures
declare OUTPUT=1 # Target mpd audio output

# Requires
source "$XDG_CONFIG_HOME/polybar/scripts/color.sh"

# Global Constants
declare ICON_UNMUTED="ﱘ"
declare ICON_MUTED="ﱙ"
declare CACHE="/run/user/$UID/mpd"

main () {
    # Get mpd status
    local status=$(mpc-mute -s $OUTPUT 2>/dev/null)

    # Get mpd volume
    local volume="$(mpc volume | grep -oP "[0-9]+")"
    [[ $volume != "" ]] && local volume="$(printf '%2s' $volume)%"

    # Get color and icon
    if [[ $status == "unmuted" ]]; then
        local color_bg=$COLOR_BACKGROUND
        local color_fg=$COLOR_GREY_4
        local color_ul=$COLOR_GREY_2
        local color_ol=$COLOR_EMPTY
        local color_string="%{F$color_fg}%{u$color_ul}%{B$color_bg}%{o$color_ol}"
        local icon=$ICON_UNMUTED
        [[ $volume != "" ]] && echo "$color_string $icon $volume" || echo ""
    elif [[ $status == "muted" ]]; then
        local color_bg=$COLOR_BACKGROUND
        local color_fg=$COLOR_GREY_2
        local color_ul=$COLOR_GREY_1
        local color_ol=$COLOR_EMPTY
        local color_string="%{F$color_fg}%{u$color_ul}%{B$color_bg}%{o$color_ol}"
        local icon=$ICON_MUTED
        echo "$color_string $icon     "
    else
        echo ""
    fi
}

loop () {
    while read event; do
        main
    done
}

main
mpc idleloop player mixer 2>/dev/null | loop
