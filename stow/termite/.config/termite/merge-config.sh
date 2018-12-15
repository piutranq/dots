#!/usr/bin/env bash

# =============================================================================
#
#   Termite configuration merge script
#
#   Author:
#       - Piu Tranquillo (https://github.com/piutranq)
#
#   Concept:
#       - conf.d/ directory includes separated config files
#       - This script merges all config files to single config file, ./config
#
# =============================================================================

main() {
    # Merging order follows this array
    local -ar LIST_OF_PATH=(
        "header"
        "colors"
        "options"
        "footer"
    )

    local TERMITE="$HOME/.config/termite"
    rm -rf "$TERMITE/config"

    for elem in ${LIST_OF_PATH[*]}
    do
        local CPATH="$TERMITE/conf.d/$elem"
        cat $CPATH >> "$TERMITE/config"
        echo "" >> "$TERMITE/config"
    done
    chmod -w "$TERMITE/config"
}

main
