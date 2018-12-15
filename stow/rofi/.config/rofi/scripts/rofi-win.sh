#!/bin/bash

ROFI_DIR="$HOME/.config/rofi"
ROFI_CONF="$ROFI_DIR/config"
ROFI_THEME="$ROFI_DIR/theme.rasi"

TITLE="缾"

$(rofi                          \
    -show window                \
    -display-window $TITLE      \
    -config         $ROFI_CONF  \
    -theme          $ROFI_THEME )

