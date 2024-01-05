#!/usr/bin/env sh

parse_config () {
    export HIDE_ON_EMPTY="$(eww get bspwm_hide_on_empty)"
    export RENDER_FMT='{
        "id": "${id}",
        "name": "${name}",
        "status": "${status}",
        "focused": "${focused}",
        "visible": "${visible}"
    }'
}

get_status () {
    # Parameters
    local workspace_id=$1

    # Each workspaces can be 3 status: "urgent" | "occupied" | "empty"
    # Query to bspc and determine the status of given workspace.
    [ $(bspc query -d "${workspace_id}.urgent" -D) ] &&\
        echo "urgent" && return 0 ||\
    [ $(bspc query -d "${workspace_id}.occupied" -D) ] &&\
        echo "occupied" && return 0 || echo "empty" && return 0
}

get_focused () {
    # Parameters
    local workspace_id=$1
    local workspace_focused=$2

    # By compare workspace ID with focused workspace,
    # check the given workspace is focused.
    [ "${workspace_id}" = "${workspace_focused}" ] \
        && echo "true" \
        || echo "false"
}

get_visible () {
    # Parameters
    local status=$1
    local focused=$2

    # If $HIDE_ON_EMPTY set "true",
    # the empty & non-focused workspaces are hidden.
    [ "${HIDE_ON_EMPTY}" = "true" ] &&\
    [ "${status}" = "empty" ] &&\
    [ "${focused}" = "false" ] &&\
        echo "false" && return 0

    echo "true"
}

render_ws () {(
    # Parameters
    local workspace_id=$1
    local workspace_focused=$2

    # Render JSON string from attributes of the given workspace
    export id=${workspace_id}
    export name=$(bspc query -d ${workspace_id} -D --names)
    export status=$(get_status ${workspace_id})
    export focused=$(get_focused ${workspace_id} ${workspace_focused})
    export visible=$(get_visible ${status} ${focused})
    echo -n ${RENDER_FMT} | envsubst
    echo -n ", "
)}

render () {
    # Parameters
    local mon_id=${1}

    local mon_name=$(bspc query -m ${mon_id} -M --names)
    local ws_focused=$(bspc query -d ${mon_id}:focused -D)

    local json="$(
        bspc query -m ${mon_id} -D | while read -r ws_id; do
            render_ws ${ws_id} ${ws_focused}
        done
    )"
    echo -n "\"${mon_name}\": [ ${json%%", "} ], "
}

render_all () {
    local json="$(
        bspc query -M | while read -r mon_id; do
            render ${mon_id}
        done
    )"
    echo "{ ${json%%", "} }"
}

loop () {
    render_all
    while read -r event; do
        render_all
    done
}

listen () {
    parse_config
    bspc subscribe \
        monitor \
        desktop \
        node_add node_remove node_flag \
        | loop
}

main () {
    local event=${1} # "scrollup | scrolldown | click | listen"

    case ${event} in
        "listen") listen;;
        "click") bspc desktop -f ${2};;
        "scrollup") bspc desktop -f prev.local;;
        "scrolldown") bspc desktop -f next.local;;
    esac
}

main ${@}