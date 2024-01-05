#!/usr/bin/env sh

parse_config () {
    export SOCKET_PATH="$(eval "echo $(eww get sxhkd_socket)")"
    export KEYCHAIN_TABLE="$(eww get sxhkd_keychain_table)"
    export FALLBACK="$(define_fallback)"
    export REGISTER_CHAINMODE=1
}

define_fallback () {
    local filter=".fallback|select(.!=null)"
    echo ${KEYCHAIN_TABLE} | jq -cMe "${filter}" && return 0
    echo '{"visible":"false"}'
}

use_fallback () {
    echo ${FALLBACK}
}

event_hotkey () {
    local filter=".\"${1}\"|select(.!= null)"
    echo "${KEYCHAIN_TABLE}" | jq -cM "${filter}"
}

event_begin () {
    REGISTER_CHAINMODE=0
}

event_end () {
    REGISTER_CHAINMODE=1
    use_fallback
}

event_command () {
    [ ${REGISTER_CHAINMODE} = 1 ] && event_end
}

loop () {
    use_fallback
    while read -r event; do
        case "${event}" in
            "H"*) event_hotkey "${event}";;
            "BBegin"*) event_begin;;
            "EEnd"*) event_end;;
            "C"*) event_command;;
        esac
    done
    use_fallback
}

main () {
    parse_config
    socat -u UNIX-CONNECT:${SOCKET_PATH} - | loop
}

main