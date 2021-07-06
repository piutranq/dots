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

    echo "$COLOR $ICON $(printf '%2s' $1)% "
}

getformat_muted () {
    local BG=$COLOR_MUTED_BG
    local FG=$COLOR_MUTED_FG
    local UL=$COLOR_MUTED_UL
    local OL=$COLOR_MUTED_OL

    local COLOR="%{F$FG}%{u$UL}%{+u}%{B$BG}%{o$OL}"
    local ICON=$ICON_MUTED

    echo "$COLOR $ICON     "
}

indicator () {
    # Get mpd status: It should be [playing] or [paused]
    local STATUS=$(mpc status 2>/dev/null | grep -oP "\[playing\]|\[paused\]")

    case $STATUS in
        # If the mpd is running correctly, print the volume
        "[playing]" | "[paused]" )
            local volume="$(mpc volume 2>/dev/null | grep -oP "[0-9]+|n/a")"
            case $volume in
                "n/a" | "" )    getformat_muted;;
                *)              getformat_unmuted $volume;;
            esac;;
        # If the mpd is not fine, print nothing
        *) echo && return 1
    esac
}

loop () {
    while read -r event; do
        indicator
    done
    echo ""
}

main () {
    if pidof mpd > /dev/null
    then
        indicator
        mpc idleloop player mixer 2>/dev/null | loop
    else
        sleep 0.1
        exit 1
    fi
}

main

