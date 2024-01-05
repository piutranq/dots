#!/usr/bin/env sh

generate_workspace_range () {
    local i=1;
    local max=$MAX_WORKSPACES
    while [ $i -le $max ]; do
        echo -n "$i "
        i=$((i+1))
    done
    echo ""
}

parse_config () {
    export SOCKET_PATH="/tmp/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"
    export MONITOR_ID=${1:-"0"}
    export PORT_NAME=$(
        hyprctl monitors |\
        grep -e "Monitor .* (ID $MONITOR_ID)" |\
        awk '{print $2}'
    )
    export MAX_WORKSPACES=$(
        eww get hyprws_workspace_max 2>/dev/null || echo "9")
    export WORKSPACES_RANGE=$(generate_workspace_range)
    export ICON_LIST=$(eww get hyprws_icons)
    export HIDE_ON_EMPTY=$(eww get hyprws_hide_on_empty)
    export RENDER_FMT='{
        "wsid": "${wsid}",
        "visible": "${visible}",
        "class": "wso_${occupied} wsf_${focused}",
        "text": "${icon}"
    }'
}

check_occupied () {
    local wnum=$(echo "$occupied_list" |\
        grep -A1 "ID $wsid" |\
        awk 'NR==2 {print $2}')
    [ ${wnum:=0} -gt 0 ] &&\
        echo "true" || echo "false"
}

check_focused () {
    [ $wsid -eq ${focused_ws} ] &&\
        echo "true" || echo "false"
}

check_visible () {
    # Check the workspace is visible
    [ "$HIDE_ON_EMPTY" = "true" ] &&\
    [ "$occupied" = "false" ] &&\
    [ "$focused" = "false" ] &&\
        echo "false" && return 0

    echo "true"
}

create_button_json () {(
    export wsid=$1
    export occupied=$(check_occupied)
    export focused=$(check_focused)
    export visible=$(check_visible)
    export icon=$(echo $ICON_LIST | awk -v id=$wsid '{print $id}')

    echo -n $RENDER_FMT | envsubst
)}

create_list_json () {
    echo -n '[ '
    for wsid in $WORKSPACES_RANGE; do
        create_button_json $wsid
        [ $wsid -eq $MAX_WORKSPACES ] || echo -n ', '
    done
    echo ' ]'
}

refresh () {
    # Do not work for invalid port name
    [ "$PORT_NAME" = "" ] && return 1

    # Check hyprws status
    ## Occupied Workspace List
    export occupied_list=$(hyprctl workspaces |\
        grep -A1 "^workspace ID.*${PORT_NAME}:")
    ## Focused Workspace
    export focused_ws=$(hyprctl monitors |\
        grep -A8 "Monitor ${PORT_NAME}" |\
        awk 'NR==7 {print $3}')

    create_list_json
}

loop () {
    while read -r event; do
        event_header=$(echo $event | awk -F '>>' '{print $1}')
        event_body=$(echo $event | awk -F '>>' '{print $2}')
        case $event_header in
            "workspace") [ $event_body != "special" ] && refresh;;
            "moveworkspace") refresh;;
            "createworkspace") refresh;;
            "destroyworkspace") refresh;;
            "openwindow") refresh;;
            "closewindow") refresh;;
        esac
    done
    echo ""
}

main () {
    parse_config $1
    refresh
    socat -u UNIX-CONNECT:${SOCKET_PATH} - | loop
}

main $1
