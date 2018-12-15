#!/bin/sh

# Command Alias
CMD_DBOX_STATUS="dropbox-cli status"

# Color Alias
source "$XDG_CONFIG_HOME/polybar/scripts/color.sh"

# Set Default Color & Icon
COLOR_BG=$COLOR_TRANSPARENT
COLOR_FG=$COLOR_GREY_4
COLOR_UL=$COLOR_GREY_2
COLOR_OL=$COLOR_EMPTY
INDICATOR_ICON=""


# Get dropbox status string
DBOX_STATUS=$($CMD_DBOX_STATUS)

# If you want print status string directly for debug, just add 'echo $DBOX_STATUS' at below line:

# echo $DBOX_STATUS

# Get dropbox status
if   [[ $(echo $DBOX_STATUS | grep "Dropbox isn't running!")     ]]; then
    INDICATOR_STATUS='OFF'
elif [[ $(echo $DBOX_STATUS | grep "Dropbox daemon stopped." )   ]]; then
    INDICATOR_STATUS='OFF'
elif [[ $(echo $DBOX_STATUS | grep "Starting..." )               ]]; then
    INDICATOR_STATUS='OFF'
elif [[ $(echo $DBOX_STATUS | grep "Connecting..." )             ]]; then
    INDICATOR_STATUS='OFF'
elif [[ $(echo $DBOX_STATUS | grep "Syncing")                    ]]; then
    INDICATOR_STATUS='SYNC'
elif [[ $(echo $DBOX_STATUS | grep "Up to date")                 ]]; then
    INDICATOR_STATUS='OK'
elif [[ $(echo $DBOX_STATUS | grep "Dropbox isn't responding!" ) ]]; then
    INDICATOR_STATUS='ERROR'
else
    INDICATOR_STATUS='UNKNOWN'
fi

#
case $INDICATOR_STATUS in
'OFF')
    COLOR_FG=$COLOR_GREY_1
    COLOR_UL=$COLOR_GREY_1
    ;;
'ERROR')
    COLOR_FG=$COLOR_YELLOW
    COLOR_UL=$COLOR_RED
    ;;
'OK')
    COLOR_FG=$COLOR_GREY_4
    COLOR_UL=$COLOR_BLUE
    ;;
'SYNC')
    COLOR_FG=$COLOR_BLUE
    COLOR_UL=$COLOR_BLUE
    ;;
*)
    COLOR_FG=$COLOR_GREY_4
    COLOR_UL=$COLOR_GREY_2
    INDICATOR_ICON=""
    ;;
esac

echo "%{F$COLOR_FG}%{u$COLOR_UL}%{B$COLOR_BG}%{o$COLOR_OL} $INDICATOR_ICON "
