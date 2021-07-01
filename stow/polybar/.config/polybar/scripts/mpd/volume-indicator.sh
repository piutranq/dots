#!/usr/bin/env sh

# Requires
. "$XDG_CONFIG_HOME/polybar/scripts/color.sh"

# Configures
# OUTPUT=1 # Target mpd audio output

# Color and Icons
readonly ICON_UNMUTED="ﱘ"
readonly ICON_MUTED="ﱙ"

readonly COLOR_UNMUTED_BG=$COLOR_BACKGROUND
readonly COLOR_UNMUTED_FG=$COLOR_GREY4
readonly COLOR_UNMUTED_UL=$COLOR_GREY2
readonly COLOR_UNMUTED_OL=$COLOR_EMPTY

readonly COLOR_MUTED_BG=$COLOR_BACKGROUND
readonly COLOR_MUTED_FG=$COLOR_GREY2
readonly COLOR_MUTED_UL=$COLOR_GREY1
readonly COLOR_MUTED_OL=$COLOR_EMPTY

getformat_unmuted () {
    local BG=$COLOR_UNMUTED_BG
    local FG=$COLOR_UNMUTED_FG
    local UL=$COLOR_UNMUTED_UL
    local OL=$COLOR_UNMUTED_OL

    local COLOR="%{F$FG}%{u$UL}%{+u}%{B$BG}%{o$OL}"
    local ICON=$ICON_UNMUTED

    export FORMAT="$COLOR $ICON $(printf '%2s' $volume)% "
}

getformat_muted () {
    local BG=$COLOR_MUTED_BG
    local FG=$COLOR_MUTED_FG
    local UL=$COLOR_MUTED_UL
    local OL=$COLOR_MUTED_OL

    local COLOR="%{F$FG}%{u$UL}%{+u}%{B$BG}%{o$OL}"
    local ICON=$ICON_MUTED

    export FORMAT="$COLOR $ICON     "
}

main () {
    # Get mpd status and volume
    local player="$(mpc status 2>/dev/null | grep -oP "\[playing\]|\[paused\]")"
    local volume="$(mpc volume 2>/dev/null | grep -oP "[0-9]+|n/a")"

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
