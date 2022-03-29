#!/usr/bin/env sh

# Requires
. "$XDG_CONFIG_HOME/polybar/scripts/color.sh"

# Configures
readonly LENGTH_MAX=60

# Color and icons
readonly ICON_PLAY=""
readonly ICON_PAUSE=""

readonly COLOR_PLAY_BG=$COLOR_BACKGROUND
readonly COLOR_PLAY_FG=$COLOR_GREY4
readonly COLOR_PLAY_UL=$COLOR_BLUE
readonly COLOR_PLAY_OL=$COLOR_EMPTY

readonly COLOR_PAUSE_BG=$COLOR_BACKGROUND
readonly COLOR_PAUSE_FG=$COLOR_GREY2
readonly COLOR_PAUSE_UL=$COLOR_GREY2
readonly COLOR_PAUSE_OL=$COLOR_EMPTY

getcolor_playing () {
    local BG=$COLOR_PLAY_BG
    local FG=$COLOR_PLAY_FG
    local UL=$COLOR_PLAY_UL
    local OL=$COLOR_PLAY_OL

    export COLOR="%{F$FG}%{u$UL}%{+u}%{B$BG}%{o$OL}"
    export ICON=$ICON_PLAY
}

getcolor_paused () {
    local BG=$COLOR_PAUSE_BG
    local FG=$COLOR_PAUSE_FG
    local UL=$COLOR_PAUSE_UL
    local OL=$COLOR_PAUSE_OL

    export COLOR="%{F$FG}%{u$UL}%{+u}%{B$BG}%{o$OL}"
    export ICON=$ICON_PAUSE
}

shrink_message () {
    [ ${#1} -gt $(($LENGTH_MAX-3)) ] && \
        echo "${1:0:$(($LENGTH_MAX-6))}..." || echo "$1"
}

indicator () {
    # Get mpd status: It should be [playing] or [paused]
    local STATUS="$(mpc status 2>/dev/null | grep -oP "\[playing\]|\[paused\]")"

    case $STATUS in
        # If the mpd is running correctly, get color from status
        "[playing]")    getcolor_playing;;
        "[paused]")     getcolor_paused;;
        # If the mpd is not fine, print nothing and wait
        *) echo && return 1
    esac

    local MESSAGE="$ICON $(nowplaying 2>/dev/null)"
    echo "$COLOR $(shrink_message "$MESSAGE" 2>/dev/null) "
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
        mpc idleloop player 2>/dev/null | loop
    else
        sleep 0.1
        exit 1
    fi
}

main

