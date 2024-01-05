#!/usr/bin/env sh

parse_config () {
    export SINK="${1}"
    export PA_PROCESS="pipewire-pulse"
    export ICON_UNMUTED=$(eww get pavol_icon_unmuted)
    export ICON_MUTED=$(eww get pavol_icon_muted)
    export MUTED_FORMAT=$(eww get pavol_muted_format)
    export RENDER_FMT='{
        "visible": "${visible}",
        "audible": "${audible}",
        "volume": "${volume}",
        "icon": "${icon}"
    }'
}

define_sink () {
    # ${1} is pulse audio sink. If empty, using default sink
    [ -z ${1} ] && pactl get-default-sink || echo ${1}
}

get_sink_status () {
    pactl list short sinks | grep ${1} |\
        grep -oE "RUNNING|IDLE|SUSPENDED"
}

get_sink_volume () {
    pamixer --get-volume-human --sink ${1} 2>/dev/null |\
        grep -oE "[0-9]+%|muted"
}

render_unmuted () {(
    export volume="${1}"
    export icon=${ICON_UNMUTED}
    export audible="true"
    export visible="true"
    echo ${RENDER_FMT} | envsubst
)}

render_muted () {(
    export volume=${MUTED_FORMAT}
    export icon=${ICON_MUTED}
    export audible="false"
    export visible="true"
    echo ${RENDER_FMT} | envsubst
)}

render_invisible () {(
    export visible="false"
    echo ${RENDER_FMT} | envsubst
)}

refresh () {
    local sink_status="$(get_sink_status ${SINK})"
    local sink_volume="$(get_sink_volume ${SINK})"

    case ${sink_status} in
        # If the sink is alive
        "RUNNING" | "IDLE" | "SUSPENDED")
            case ${sink_volume} in
            "muted" | "" ) render_muted;;
            *) render_unmuted ${sink_volume};;
            esac;;
        # If the sink is dead
        *) render_invisible;;
    esac
}

loop () {
    while read -r event; do
        echo ${event} \
        | grep -E "'change' on sink #[0-9]+" 1>/dev/null && refresh
    done
    echo ""
}

listen () {
    while true; do
        if pidof ${PA_PROCESS} > /dev/null
        then
            refresh
            pactl subscribe 2>/dev/null | loop
        else
            sleep 1 # If pulseaudio is dead, check pa every 1sec
        fi
    done
}

main () {
    local event=${1} # "scrollup | scrolldown | click | listen"
    parse_config "$(define_sink ${2})" # ${2} is pulse audio sink

    case ${event} in
        "listen") listen;;
        "click") pamixer -t --sink $SINK;;
        "scrollup") pamixer -i 5 --sink $SINK;;
        "scrolldown") pamixer -d 5 --sink $SINK;;
    esac
}

main ${@}