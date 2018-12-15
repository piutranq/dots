#!/bin/bash

ROFI_DIR="$HOME/.config/rofi"
ROFI_CONF="$ROFI_DIR/config"
ROFI_THEME="$ROFI_DIR/theme.rasi"
NF_LIST="$ROFI_DIR/nerdfont-cheatsheet"

TITLE=""

SELECTED=$(cat $NF_LIST |               \
    rofi    -dmenu -i                   \
    -p      $TITLE                      \
    -config $ROFI_CONF                  \
    -theme  $ROFI_THEME                 )

echo $SELECTED | awk '{ printf $2 }' | xclip -selection CLIPBOARD
