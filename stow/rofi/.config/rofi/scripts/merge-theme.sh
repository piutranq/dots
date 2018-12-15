#!/usr/bin/env bash

# =============================================================================
#
#   Rofi theme merge script
#
#   Author:
#       - Piu Tranquillo (https://github.com/piutranq)
#
# =============================================================================

# Configuration
THEME_NAME="sidebar.css"

main() {
    # Merging order follows this array
    local -ar LIST_OF_PATH=(
        "color.css"
        $THEME_NAME
    )

    local ROFI="$HOME/.config/rofi"
    rm -rf "$ROFI/theme.rasi"

    for elem in ${LIST_OF_PATH[*]}
    do
        local CPATH="$ROFI/theme.d/$elem"
        cat $CPATH >> "$ROFI/theme.rasi"
        echo "" >> "$ROFI/theme.rasi"
    done
    chmod -w "$ROFI/theme.rasi"
}

main
