#!/usr/bin/env bash

ROFI_DIR="$XDG_CONFIG_HOME/rofi"
ROFI_CONF="$ROFI_DIR/config"
ROFI_THEME="$ROFI_DIR/theme.rasi"

TITLE=""

exec rofi\
    -show run\
    -display-run    $TITLE\
    -config         $ROFI_CONF\
    -theme          $ROFI_THEME\
    -theme-str      "#window    { height: 0; }"\
    -theme-str      "#listview  { lines: 1;  }"
