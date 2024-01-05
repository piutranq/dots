#!/usr/bin/env sh

parse_config () {
    export ICON_OK=$(eww get maestral_icon_ok)
    export ICON_UNKNOWN=$(eww get maestral_icon_unknown)
}

check_status() {
    echo ${MAESTRAL_STATUS} | grep "${1}" > /dev/null
}

refresh () {
    local MAESTRAL_STATUS=$(maestral status)
    status='maestral_unknown'
    check_status "is not running"    && status='off'
    check_status "Connecting"        && status='off'
    check_status "Paused"            && status='off'
    check_status "Connected"         && status='ok'
    check_status "Up to date"        && status='ok'
    check_status "Creating"          && status='sync'
    check_status "Syncing"           && status='sync'
    check_status "Fetching"          && status='sync'
    check_status "Indexing"          && status='sync'
    check_status "Could not"         && status='error'

    [ "${status}" != "unknown" ] &&\
        icon=${ICON_OK} || icon=${ICON_UNKNOWN}

    echo "{ \"icon\": \"${icon}\", \"status\": \"${status}\" }"
}

main () {
    parse_config
    while true; do
        refresh
        sleep 5
    done
}

main
