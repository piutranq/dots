#!/bin/sh

source "$XDG_CONFIG_HOME/polybar/scripts/color.sh"

# Global Constants
declare -ri CONST_MAX_LENGTH=60

declare -r ICON_PLAY=""
declare -r ICON_PAUSE=""

# Get mpd status by using mpc
get_status () {
    if   [[ $(mpc 2>/dev/null | grep "^\[playing\]") ]]; then
        export STATUS="PLAY"
    elif [[ $(mpc 2>/dev/null | grep "^\[paused\]")  ]]; then
        export STATUS="PAUSE"
    else
        echo ""
        exit 1
    fi
}

set_color () {
    if   [[ $STATUS == "PLAY"  ]]; then
        local -r color_bg=$COLOR_BACKGROUND
        local -r color_fg=$COLOR_GREY_4
        local -r color_ul=$COLOR_BLUE
        local -r color_ol=$COLOR_EMPTY
    elif [[ $STATUS == "PAUSE" ]]; then
        local -r color_bg=$COLOR_BACKGROUND
        local -r color_fg=$COLOR_GREY_2
        local -r color_ul=$COLOR_GREY_2
        local -r color_ol=$COLOR_EMPTY
    elif [[ $STATUS == "OFF"   ]]; then
        local -r color_bg=$COLOR_EMPTY
        local -r color_fg=$COLOR_EMPTY
        local -r color_ul=$COLOR_EMPTY
        local -r color_ol=$COLOR_EMPTY
    fi
    export COLOR_STRING="%{F$color_fg}%{u$color_ul}%{B$color_bg}%{o$color_ol}"
}

# Echo info message
echo_info_msg () {
    # Get artist and title
    local -r artist=$( mpc -f "%artist%" 2>/dev/null | head -n 1)
    local -r title=$(  mpc -f "%title%"  2>/dev/null | head -n 1)

    # Get icon
    [[ $STATUS == "PLAY"  ]] && local -r icon=$ICON_PLAY
    [[ $STATUS == "PAUSE" ]] && local -r icon=$ICON_PAUSE

    # Make message
    local message=""
    [[ $artist == "" ]] && \
        message="$icon $title" || message="$icon $artist - $title"

    # Shrink message when length is too long
    [[ ${#message} -gt $CONST_MAX_LENGTH-3 ]] && \
        message=$(echo "${message:0:$CONST_MAX_LENGTH-6}...")

    # Echo message
    echo "$COLOR_STRING $message "
}

# Main Function
main () {
    get_status
    set_color
    echo_info_msg
}

main
