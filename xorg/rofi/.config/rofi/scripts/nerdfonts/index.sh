#!/usr/bin/env bash

parse_config () {
    # Remote Data Path
    export NF_REPO="https://github.com/ryanoasis/nerd-fonts"
    export NF_BRANCH="v3.1.1"
    export NF_URL="${NF_REPO}/blob/${NF_BRANCH}/glyphnames.json"

    # Local Data Path
    export NF_CACHE="${XDG_CACHE_HOME}/rofi-nerdfonts-data.csv"

    # Rofi Path & Config
    export ROFI_DIR="${XDG_CONFIG_HOME}/rofi"
    export ROFI_COLOR="${ROFI_DIR}/shared/colors.rasi"
    export ROFI_ICON=""

    # etc
    export COLOR_ICON="blue"
}

join_keys () {
    [ ${#1} -eq 0 ] && echo ".*" \
    || {
        for arg in "$@"; do
            keys+="${arg}|"
        done
        echo ${keys} | sed 's/\x7C$//'
    }
}

generate_data () {
    [ ! -f ${NF_CACHE} ] && curl ${NF_URL} |\
        jq '.payload.blob.rawLines[0]' -r |\
        jq 'del(.METADATA) | to_entries' |\
        jq '.[] | "\(.value["code"]) \(.value["char"]) \(.key)"' -r \
        > "${NF_CACHE}"
}

print_entry () {
    local color=$(
        cat "${ROFI_COLOR}" |\
        grep -E "${COLOR_ICON}: #[0-9a-fA-F]+" |\
        awk '{print $2}' | sed 's/;//')
    printf "${1}\0icon\x1f<span color='${color}'>${2}</span>\n"
}

select_entry () {
    local search_keys=$(join_keys "${@}")
    rg --ignore-case "${search_keys}" "${NF_CACHE}" |\
        while IFS=" " read -r code char key; do
            print_entry "${code} | ${key}" "${char}"
        done |\
        rofi -dmenu -i \
            -show-icons "true" \
            -theme-str "textbox-prompt-colon {
                str: \"${ROFI_ICON}\";
            }" |\
        awk '{ printf $1 }'
}

send_to_clip () {
    [ ${#1} -eq 0 ] && exit 1
    local code=${1}
    local data=$(cat "${NF_CACHE}" | grep "^${code} ")
    local char=$(echo "${data}" | awk '{ printf $2 }')

    printf ${char} | xclip -selection CLIPBOARD
}

main () {
    parse_config
    generate_data
    send_to_clip "$(select_entry ${@})"
}

main "${@}"
