#!/usr/bin/env bash

# Requires
source "$XDG_CONFIG_HOME/polybar/scripts/color.sh"

# Global Constants
declare -ri CONST_MAX_LENGTH=60

declare -r ICON_PLAY=""
declare -r ICON_PAUSE=""

declare -r COLOR_PLAY_BG=$COLOR_BACKGROUND
declare -r COLOR_PLAY_FG=$COLOR_GREY_4
declare -r COLOR_PLAY_UL=$COLOR_BLUE
declare -r COLOR_PLAY_OL=$COLOR_EMPTY

declare -r COLOR_PAUSE_BG=$COLOR_BACKGROUND
declare -r COLOR_PAUSE_FG=$COLOR_GREY_2
declare -r COLOR_PAUSE_UL=$COLOR_GREY_2
declare -r COLOR_PAUSE_OL=$COLOR_EMPTY

get_mpd_status () {
    [[ $(mpc 2>/dev/null | grep "^\[playing\]") ]] &&\
        return 0  ||\
    [[ $(mpc 2>/dev/null | grep "^\[paused\]")  ]] &&\
        return 1 ||\
    echo "" && exit 1
}

set_color_icon () {
    get_mpd_status
    if [[ $? -eq 0  ]]; then
        local -r color_bg=$COLOR_PLAY_BG
        local -r color_fg=$COLOR_PLAY_FG
        local -r color_ul=$COLOR_PLAY_UL
        local -r color_ol=$COLOR_PLAY_OL
        local -r icon=$ICON_PLAY
    elif [[ $? -eq 1 ]]; then
        local -r color_bg=$COLOR_PAUSE_BG
        local -r color_fg=$COLOR_PAUSE_FG
        local -r color_ul=$COLOR_PAUSE_UL
        local -r color_ol=$COLOR_PAUSE_OL
        local -r icon=$ICON_PAUSE
    fi

    # Make color string
    export COLOR="%{F$color_fg}%{u$color_ul}%{B$color_bG}%{o$color_ol}"
    export ICON=$icon
}

main () {

    set_color_icon
    local -r song=$(nowplaying)
    local message="$ICON $song"

    [[ ${#message} -gt $CONST_MAX_LENGTH-3 ]] &&\
        message="${message:0:$CONST_MAX_LENGTH-6}..."

    echo "$COLOR $message "
}

loop () {
    while read event; do
        main
    done
}

main
mpc idleloop player 2>/dev/null | loop
