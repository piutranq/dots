#!/bin/bash

ROFI_DIR="$HOME/.config/rofi"
ROFI_CONF="$ROFI_DIR/config"
ROFI_THEME="$ROFI_DIR/theme.rasi"

TITLE=""

$(rofi                      \
    -show drun              \
    -display-drun $TITLE    \
    -config $ROFI_CONF      \
    -theme $ROFI_THEME      )
