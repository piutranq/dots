#!/usr/bin/env sh

# Color Alias
. "$XDG_CONFIG_HOME/polybar/scripts/color.sh"

# Set Default Color & Icon
COLOR_BG=$COLOR_BACKGROUND
COLOR_FG=$COLOR_GREY4
COLOR_UL=$COLOR_GREY2
COLOR_OL=$COLOR_EMPTY
INDICATOR_ICON=""

# Set the maestral profile (Config Name)
readonly MAESTRAL_PROFILE="maestral"

# Get maestral status string
readonly MAESTRAL_STATUS=$(maestral status)

# Check the maestral status
getstatus() {
    echo $MAESTRAL_STATUS | grep "$1" > /dev/null
}

# Get dropbox status
INDICATOR_STATUS='UNKNOWN'
getstatus "is not running"    && INDICATOR_STATUS='OFF'
getstatus "Connecting"        && INDICATOR_STATUS='OFF'
getstatus "Paused"            && INDICATOR_STATUS='OFF'
getstatus "Connected"         && INDICATOR_STATUS='OK'
getstatus "Up to date"        && INDICATOR_STATUS='OK'
getstatus "Creating"          && INDICATOR_STATUS='SYNC'
getstatus "Syncing"           && INDICATOR_STATUS='SYNC'
getstatus "Fetching"          && INDICATOR_STATUS='SYNC'
getstatus "Indexing"          && INDICATOR_STATUS='SYNC'
getstatus "Could not"         && INDICATOR_STATUS='ERROR'

case $INDICATOR_STATUS in
'OFF')
    COLOR_FG=$COLOR_GREY1
    COLOR_UL=$COLOR_GREY1
    ;;
'ERROR')
    COLOR_FG=$COLOR_YELLOW
    COLOR_UL=$COLOR_RED
    ;;
'OK')
    COLOR_FG=$COLOR_GREY4
    COLOR_UL=$COLOR_BLUE
    ;;
'SYNC')
    COLOR_FG=$COLOR_BLUE
    COLOR_UL=$COLOR_BLUE
    ;;
*)
    COLOR_FG=$COLOR_GREY4
    COLOR_UL=$COLOR_GREY2
    INDICATOR_ICON=""
    ;;
esac

echo "%{F$COLOR_FG}%{u$COLOR_UL}%{+u}%{B$COLOR_BG}%{o$COLOR_OL} $INDICATOR_ICON "
