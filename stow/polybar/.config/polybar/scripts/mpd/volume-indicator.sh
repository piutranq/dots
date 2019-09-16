#!/usr/bin/env bash

# Requires
source "$XDG_CONFIG_HOME/polybar/scripts/color.sh"

# Configures
declare OUTPUT=1 # Target mpd audio output

# Color and Icons
declare -r ICON_UNMUTED="ﱘ"
declare -r ICON_MUTED="ﱙ"

declare -r COLOR_UNMUTED_BG=$COLOR_BACKGROUND
declare -r COLOR_UNMUTED_FG=$COLOR_GREY_4
declare -r COLOR_UNMUTED_UL=$COLOR_GREY_2
declare -r COLOR_UNMUTED_OL=$COLOR_EMPTY

declare -r COLOR_MUTED_BG=$COLOR_BACKGROUND
declare -r COLOR_MUTED_FG=$COLOR_GREY_2
declare -r COLOR_MUTED_UL=$COLOR_GREY_1
declare -r COLOR_MUTED_OL=$COLOR_EMPTY

getformat_unmuted () {
    local -r BG=$COLOR_UNMUTED_BG
    local -r FG=$COLOR_UNMUTED_FG
    local -r UL=$COLOR_UNMUTED_UL
    local -r OL=$COLOR_UNMUTED_OL

    local -r COLOR="%{F$FG}%{u$UL}%{B$BG}%{o$OL}"
    local -r ICON=$ICON_UNMUTED

    export FORMAT="$COLOR $ICON $(printf '%2s' $volume)% "
}

getformat_muted () {
    local -r BG=$COLOR_MUTED_BG
    local -r FG=$COLOR_MUTED_FG
    local -r UL=$COLOR_MUTED_UL
    local -r OL=$COLOR_MUTED_OL

    local -r COLOR="%{F$FG}%{u$UL}%{B$BG}%{o$OL}"
    local -r ICON=$ICON_MUTED

    export FORMAT="$COLOR $ICON     "
}

main () {
    # Get mpd status and volume
    local -r player="$(mpc status 2>/dev/null | grep -oP "\[playing\]|\[paused\]")"
    local -r volume="$(mpc volume 2>/dev/null | grep -oP "[0-9]+|n/a")"

    # Get format
    case $volume in
        "n/a" | "" )    getformat_muted;;
        *)              getformat_unmuted;;
    esac

    # echo
    case $player in
        "[playing]" | "[paused]" )  echo "$FORMAT";;
        *)                          echo "";;
    esac
}

loop () {
    while read -r event; do
        main
    done
    echo ""
}

main
mpc idleloop player mixer 2>/dev/null | loop
