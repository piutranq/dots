#!/usr/bin/env sh

# Color Alias
. "$XDG_CONFIG_HOME/polybar/scripts/color.sh"

# Set Default Color & Icon
COLOR_BG=$COLOR_BACKGROUND
COLOR_FG=$COLOR_GREY4
COLOR_UL=$COLOR_GREY2
COLOR_OL=$COLOR_EMPTY
INDICATOR_ICON=""

# Get dropbox status string
readonly DBOX_STATUS=$(dropbox-cli status)

# Check the dropbox status
dropbox_status() {
    echo $DBOX_STATUS | grep "$1" > /dev/null
}

# Get dropbox status
INDICATOR_STATUS='UNKNOWN'
dropbox_status "isn't running!"    && INDICATOR_STATUS='OFF'
dropbox_status "daemon stopped."   && INDICATOR_STATUS='OFF'
dropbox_status "Starting..."       && INDICATOR_STATUS='OFF'
dropbox_status "Connecting..."     && INDICATOR_STATUS='OFF'
dropbox_status "Syncing"           && INDICATOR_STATUS='SYNC'
dropbox_status "Up to date"        && INDICATOR_STATUS='OK'
dropbox_status "isn't responding!" && INDICATOR_STATUS='ERROR'

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
