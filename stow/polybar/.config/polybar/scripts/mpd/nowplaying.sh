#!/usr/bin/env bash

# Requires
source "$XDG_CONFIG_HOME/polybar/scripts/color.sh"

# Global Constants
declare -ri LENGTH_MAX=60

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

set_color_icon () {
    local -r status="$(mpc status)"
    if [[ $status == *"[playing]"* ]]; then
        local -r color_bg=$COLOR_PLAY_BG
        local -r color_fg=$COLOR_PLAY_FG
        local -r color_ul=$COLOR_PLAY_UL
        local -r color_ol=$COLOR_PLAY_OL
        local -r icon=$ICON_PLAY
    elif [[ $status == *"[paused]"* ]]; then
        local -r color_bg=$COLOR_PAUSE_BG
        local -r color_fg=$COLOR_PAUSE_FG
        local -r color_ul=$COLOR_PAUSE_UL
        local -r color_ol=$COLOR_PAUSE_OL
        local -r icon=$ICON_PAUSE
    else
        echo "" && exit 1
    fi

    # Make color string
    export COLOR="%{F$color_fg}%{u$color_ul}%{B$color_bG}%{o$color_ol}"
    export ICON=$icon
}

main () {
    set_color_icon
    local -r song=$(nowplaying)
    local msg="$ICON $song"

    [[ ${#msg} -gt $LENGTH_MAX-3 ]] && \
        msg="${msg:0:$LENGTH_MAX-6}..."

    echo "$COLOR $msg "
}

loop () {
    while read event; do
        main
    done
}

main
mpc idleloop player 2>/dev/null | loop
