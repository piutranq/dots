#!/usr/bin/env bash

source "$XDG_CONFIG_HOME/polybar/scripts/color.sh"

# Global Constants
declare -ri CONST_MAX_LENGTH=60

declare -r ICON_PLAY=""
declare -r ICON_PAUSE=""

declare -r FIFO="/run/user/$UID/mpc-fifo/fifo"

main () {

    # Get mpd status
    if   [[ $(mpc 2>/dev/null | grep "^\[playing\]") ]]; then
        export STATUS="PLAY"
    elif [[ $(mpc 2>/dev/null | grep "^\[paused\]")  ]]; then
        export STATUS="PAUSE"
    else
        export STATUS="OFF"
    fi

    # If mpd is playing, echo song info.
    if [[ $STATUS != "OFF" ]]; then

        # Get artist and title
        local -r artist=$( mpc -f "%artist%" 2>/dev/null | head -n 1)
        local -r title=$(  mpc -f "%title%"  2>/dev/null | head -n 1)

        # Get color and icon
        if [[ $STATUS == "PLAY"  ]]; then
            local -r color_bg=$COLOR_BACKGROUND
            local -r color_fg=$COLOR_GREY_4
            local -r color_ul=$COLOR_BLUE
            local -r color_ol=$COLOR_EMPTY
            local -r icon=$ICON_PLAY
        elif [[ $STATUS == "PAUSE" ]]; then
            local -r color_bg=$COLOR_BACKGROUND
            local -r color_fg=$COLOR_GREY_2
            local -r color_ul=$COLOR_GREY_2
            local -r color_ol=$COLOR_EMPTY
            local -r icon=$ICON_PAUSE
        fi

        # Make color string
        local -r color_string="%{F$color_fg}%{u$color_ul}%{B$color_bg}%{o$color_ol}"

        # Make message
        local message=""
        [[ $artist == "" ]] && \
            message="$icon $title" || message="$icon $artist - $title"

        # Shrink message when length is too long
        [[ ${#message} -gt $CONST_MAX_LENGTH-3 ]] && \
            message=$(echo "${message:0:$CONST_MAX_LENGTH-6}...")

        # Echo message
        echo "$color_string $message "

    # If mpd is not playing, echo empty.
    else
        echo ""
    fi
}

loop () {
    while read -r event; do
        main
    done
}

main
mpc idleloop player | loop
