#!/usr/bin/env bash

parse_config () {
    # Rofi Path & Config
    export ROFI_DIR="${XDG_CONFIG_HOME}/rofi"
    export ROFI_COLOR="${ROFI_DIR}/shared/colors.rasi"
    export THEME="${ROFI_DIR}/confirm.rasi"

    # Arguments
    export PROMPT="${1:-"Confirm Message"}"
    export ICON_PROMPT="${2:-""}"

    # Entries
    export KEY_TRUE="Ok"
    export KEY_FALSE="Cancel"
    export ICON_TRUE="󰄬"
    export ICON_FALSE="󰜺"

    # etc
    export COLOR_ICON="blue"
}

print_entry () {
    local color=$(
        cat "${ROFI_COLOR}" |\
        grep -E "${COLOR_ICON}: #[0-9a-fA-F]+" |\
        awk '{print $2}' | sed 's/;//')
    printf "${1}\0icon\x1f<span color='${color}'>${2}</span>\n"
}

select_entry () {
    local entry_true="${KEY_TRUE};${ICON_TRUE}"
    local entry_false="${KEY_FALSE};${ICON_FALSE}"
    local selected=$(printf "${entry_true}\n${entry_false}\n" |\
        while IFS=";" read -r key icon; do
            print_entry "${key}" "${icon}"
        done |\
        rofi -dmenu -i -theme "${THEME}" \
            -p "${PROMPT}" \
            -theme-str "textbox-prompt-colon {
                str:\"${ICON_PROMPT}\"; 
            }" |\
        awk '{ printf $1 }'
    )
    [ "${selected}" = "${KEY_TRUE}" ] && echo "true" || echo "false"
}

main () {
    parse_config "$@"
    select_entry
}

main "$@"