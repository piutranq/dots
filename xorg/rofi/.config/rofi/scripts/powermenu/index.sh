#!/usr/bin/env bash

parse_config () {
    # Path
    export ROFI_DIR="${XDG_CONFIG_HOME}/rofi"
    export ROFI_COLOR="${ROFI_DIR}/shared/colors.rasi"

    export BASEDIR="$(realpath -s $(dirname $0))"
    export DATA="${BASEDIR}/config.json"
    export THEME="${ROFI_DIR}/powermenu.rasi"

    # Icons
    export ICON_PROMPT=""

    # etc
    export COLOR_ICON="blue"
}

rofi_confirm () {
    local key=${1}
    local value=${2}
    local icon=${3}
    local message="Confirm to ${key}"
    ${ROFI_DIR}/scripts/confirm/index.sh "${message}" "${icon}"
}

print_entry () {
    local color=$(
        cat "${ROFI_COLOR}" |\
        grep -E "${COLOR_ICON}: #[0-9a-fA-F]+" |\
        awk '{print $2}' | sed 's/;//')
    printf "${1}\0icon\x1f<span color='${color}'>${2}</span>\n"
}

select_entry () {
    cat "${DATA}" |\
        jq '.entries.[] | "\(.key);\(.icon)"' -r |\
        while IFS=";" read -r key icon; do
            print_entry "${key}" "${icon}"
        done |\
        rofi -dmenu -i -theme "${THEME}" \
            -p "$(whoami)@$(uname -n)" \
            -theme-str "textbox-prompt-colon {
                str:\"${ICON_PROMPT}\";
            }" |\
        awk '{ printf $1 }'
}

execute_entry () {
    [ ${#1} -eq 0 ] && exit 1
    local key=${1}
    local data=$(cat "${DATA}" | jq -r --arg KEY "${key}" \
        '.entries.[] | select(.key==$KEY)')
    local value=$(echo "${data}" | jq -r '.value')
    local icon=$(echo "${data}" | jq -r '.icon')
    local need_confirm=$(echo "${data}" | jq -r '.confirm')

    if [ "${need_confirm}" = "true" ]; then
        local confirm_result=$(
            rofi_confirm "${key}" "${value}" "${icon}"
        )
        # KEEP USING "if", DON'T USE CONTIDIONAL OPERATOR
        if [ "${confirm_result}" = "true" ]; then
            exec ${value}
        fi
    elif [ ${need_confirm} = "false" ]; then
        exec ${value}
    fi

}

main () {
    parse_config
    execute_entry $(select_entry)
}

main