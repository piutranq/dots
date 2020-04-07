#!/usr/bin/env bash

# Requires
source "$XDG_CONFIG_HOME/polybar/scripts/color.sh"

# Configures
declare -ri LENGTH_MAX=60

# Color and icons
declare -r ICON_PLAY=""
declare -r ICON_PAUSE=""

declare -r COLOR_PLAY_BG=$COLOR_BACKGROUND
declare -r COLOR_PLAY_FG=$COLOR_GREY4
declare -r COLOR_PLAY_UL=$COLOR_BLUE
declare -r COLOR_PLAY_OL=$COLOR_EMPTY

declare -r COLOR_PAUSE_BG=$COLOR_BACKGROUND
declare -r COLOR_PAUSE_FG=$COLOR_GREY2
declare -r COLOR_PAUSE_UL=$COLOR_GREY2
declare -r COLOR_PAUSE_OL=$COLOR_EMPTY

getcolor_playing () {
    local -r BG=$COLOR_PLAY_BG
    local -r FG=$COLOR_PLAY_FG
    local -r UL=$COLOR_PLAY_UL
    local -r OL=$COLOR_PLAY_OL

    export COLOR="%{F$FG}%{u$UL}%{B$BG}%{o$OL}"
    export ICON=$ICON_PLAY
}

getcolor_paused () {
    local -r BG=$COLOR_PAUSE_BG
    local -r FG=$COLOR_PAUSE_FG
    local -r UL=$COLOR_PAUSE_UL
    local -r OL=$COLOR_PAUSE_OL

    export COLOR="%{F$FG}%{u$UL}%{B$BG}%{o$OL}"
    export ICON=$ICON_PAUSE
}

shrink_message () {
    [[ ${#1} -gt $LENGTH_MAX-3 ]] && \
        echo "${1:0:$LENGTH_MAX-6}..." || echo "$1"
}

main () {
    local -r STATUS="$(mpc status 2>/dev/null | grep -oP "\[playing\]|\[paused\]")"

    case $STATUS in
        "[playing]")    getcolor_playing;;
        "[paused]")     getcolor_paused;;
        *)              echo && return 1
    esac

    local MESSAGE="$ICON $(nowplaying 2>/dev/null)"
    echo "$COLOR $(shrink_message "$MESSAGE" 2>/dev/null) "
}

loop () {
    while read -r event; do
        main
    done
    echo ""
}

main
mpc idleloop player 2>/dev/null | loop
