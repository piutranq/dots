#!/usr/bin/env bash

ROFI_DIR="$XDG_CONFIG_HOME/rofi"
ROFI_CONF="$ROFI_DIR/config"
ROFI_THEME="$ROFI_DIR/theme.rasi"

TITLE="⏻"

OPTION_LOCKSCREEN="Lockscreen"
OPTION_LOGOUT="Logout"
OPTION_SUSPEND="Suspend"
OPTION_POWEROFF="Poweroff"
OPTION_REBOOT="Reboot"

OPTIONS=()
OPTIONS+=($OPTION_LOCKSCREEN)
OPTIONS+=($OPTION_LOGOUT)
OPTIONS+=($OPTION_SUSPEND)
OPTIONS+=($OPTION_HIBERNATE)
OPTIONS+=($OPTION_POWEROFF)
OPTIONS+=($OPTION_REBOOT)

SELECTED=$(\
    printf '%s\n' "${OPTIONS[@]}" | \
    rofi -dmenu -i                  \
    -p          $TITLE              \
    -config     $ROFI_CONF          \
    -theme      $ROFI_THEME         )

case $SELECTED in
    $OPTION_LOCKSCREEN) lockscreen          ;;
    $OPTION_LOGOUT)     bspc quit           ;;
    $OPTION_SUSPEND)    systemctl suspend   ;;
    $OPTION_POWEROFF)   systemctl poweroff  ;;
    $OPTION_REBOOT)     systemctl reboot    ;;
    *)                                      ;;
esac
