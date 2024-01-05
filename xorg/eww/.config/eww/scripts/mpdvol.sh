#!/usr/bin/env sh

parse_config () {
    export ICON_UNMUTED=$(eww get mpdvol_icon_unmuted)
    export ICON_MUTED=$(eww get mpdvol_icon_muted)
    export MUTED_FORMAT=$(eww get mpdvol_muted_format)
    export RENDER_FMT='{
        "visible": "${visible}",
        "audible": "${audible}",
        "volume": "${volume}",
        "icon": "${icon}"
    }'
}

render_unmuted () {(
    export volume="$1%"
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

render () {(
    local mpdstatus="$(mpc status 2>/dev/null |\
        grep -oP "\[playing\]|\[paused\]")"
    local mpdvolume="$(mpc volume 2>/dev/null |\
        grep -oP "[0-9]+|n/a")"

    case ${mpdstatus} in
        # If the mpd is fine
        "[playing]" | "[paused]" )
            case ${mpdvolume} in
                "n/a" | "" ) render_muted;;
                *) render_unmuted ${mpdvolume};;
            esac;;
        # If the mpd is not fine
        *) render_invisible;;
    esac
)}

loop () {
    render
    while read -r event; do
        render
    done
    render_invisible
}

listen () {
    parse_config
    while true; do
        mpc idleloop player mixer 2>/dev/null | loop
    done
}

main () {
    event=${1} # "scrollup | scrolldown | click | listen"

    case ${event} in
        "listen") listen;;
        "click") mpc toggleoutput 1;;
        "scrollup") mpc volume +5;;
        "scrolldown") mpc volume -5;;
    esac
}

main ${@}