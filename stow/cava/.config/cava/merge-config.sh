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
        "colors"
        "options"
    )

    local CAVA="$HOME/.config/cava"
    rm -rf "$CAVA/config"

    for elem in ${LIST_OF_PATH[*]}
    do
        local CPATH="$CAVA/conf.d/$elem"
        cat $CPATH >> "$CAVA/config"
        echo "" >> "$CAVA/config"
    done
}

main
