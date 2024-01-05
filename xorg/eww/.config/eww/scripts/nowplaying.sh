#!/usr/bin/env sh

parse_config () {
    export ICON_PLAYING=$(eww get nowplaying_icon_playing)
    export ICON_PAUSED=$(eww get nowplaying_icon_paused)
    export RENDER_FMT='{
        "status": "${status}",
        "icon": "${icon}",
        "title": "${title}"
    }'
}

render_off () {(echo ${RENDER_FMT} | envsubst)}

render_on () {(
    # Get mpd status: It should be [playing] or [paused]
    export status="$(mpc status 2>/dev/null |\
        grep -oP "\[playing\]|\[paused\]")"
    export title="$(nowplaying 2>/dev/null)"

    case ${status} in
        "[playing]")
            export status="playing"
            export icon=${ICON_PLAYING}
        ;;
        "[paused]")
            export status="paused"
            export icon=${ICON_PAUSED}
        ;;
        *)
            export icon=""
    esac

    echo ${RENDER_FMT} | envsubst
)}

loop () {
    render_on
    while read -r event; do
        render_on
    done
    render_off
}

main () {
    parse_config
    while true; do
        mpc idleloop player 2>/dev/null | loop
    done
}

main
