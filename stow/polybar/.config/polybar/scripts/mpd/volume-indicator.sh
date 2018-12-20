#!/usr/bin/env bash

# Configures
declare -r OUTPUT=1 # Target mpd audio output

# Requires
source "$XDG_CONFIG_HOME/polybar/scripts/color.sh"

# Global Constants
declare -r ICON_UNMUTED="ﱘ"
declare -r ICON_MUTED="ﱙ"
declare -r GETVOL="mpc volume | egrep -P \"[0-9]+\""
declare -r CACHE="/run/user/$UID/mpd"

main () {
    # Get mpd status
    local -r status=$(mpc-mute -s $OUTPUT)

    # Get color and icon
    if [[ $status == "unmuted" ]]; then
        local -r color_bg=$COLOR_BACKGROUND
        local -r color_fg=$COLOR_GREY_4
        local -r color_ul=$COLOR_GREY_2
        local -r color_ol=$COLOR_EMPTY
        local -r icon=$ICON_UNMUTED
        local -r volume="$(mpc volume | grep -oP "[0-9]+")%"
    elif [[ $status == "muted" ]]; then
        local -r color_bg=$COLOR_BACKGROUND
        local -r color_fg=$COLOR_GREY_2
        local -r color_ul=$COLOR_GREY_1
        local -r color_ol=$COLOR_EMPTY
        local -r icon=$ICON_MUTED
        local -r volume=""
    fi

    # Make color string
    local -r color_string="%{F$color_fg}%{u$color_ul}%{B$color_bg}%{o$color_ol}"

    # Make message
    message=$(printf '%4s' $volume)

    echo "$color_string $icon $message "
}

loop () {
    while read -r event; do
        main
    done
}

main
mpc idleloop mixer | loop
