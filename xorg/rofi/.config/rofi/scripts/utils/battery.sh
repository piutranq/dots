#/usr/bin/env sh

parse_config () {
    export BAT_NAME="BAT1"
    export RENDER_FMT='{
        "visible": "${visible}",
        "status": "${status}",
        "icon": "${icon}",
        "capacity": "${capacity}"
    }'
    export HIDE_ON_FULL="false"
    export HIDE_ON_UNKNOWN="true"

    export THRESHOLDS="15 30 70 90"
    for i in 1 2 3 4; do
        export THRESHOLD_$i=$(
            echo ${THRESHOLDS} |\
            awk -v id=$i '{print $id}'
        )
    done

    export ICONS="󰂄 󰂄 󰂃 󰁹 󰂁 󰁾 󰁻 󰂎 "
    for i in 1 2 3 4 5 6 7 8 9; do
        export ICON_$i=$(echo ${ICONS} | awk -v id=$i '{print $id}')
    done

    export STATUS_1="full"
    export STATUS_2="charging"
    export STATUS_3="notcharging"
    export STATUS_4="veryhigh"
    export STATUS_5="high"
    export STATUS_6="middle"
    export STATUS_7="low"
    export STATUS_8="verylow"
    export STATUS_9="unknown"
}

info () {
    bpath="/sys/class/power_supply/${1}"
    pname="${2}"

    [ -e "${bpath}" ] || {
        echo "Battery ${1} is not found." 1>&2
        return 1
    }

    btype="$(cat "${bpath}/type" 2>/dev/null)"
    [ "${btype}" = "Battery" ] || {
        echo "Battery ${1} is not battery." 1>&2
        return 1
    }

    bparam="$(cat "${bpath}/${pname}" 2>/dev/null)"
    [ -n "${bparam}" ] || {
        echo "Parameter \"${pname}\" is invalid" 1>&2
        return 1
    }

    echo "${bparam}"
    return 0
}

get_status () {
    bat_status=${1}
    bat_capacity=${2}
    case "${bat_status}" in
        "Full") echo "${STATUS_1}" && return 0;;
        "Charging") echo "${STATUS_2}" && return 0;;
        "Notcharging") echo "${STATUS_3}" && return 0;;
        "Discharging")
            [ "${bat_capacity}" -lt "0" ] &&\
                echo "${STATUS_9}" && return 0
            [ "${bat_capacity}" -lt "${THRESHOLD_1}" ] &&\
                echo "${STATUS_8}" && return 0
            [ "${bat_capacity}" -lt "${THRESHOLD_2}" ] &&\
                echo "${STATUS_7}" && return 0
            [ "${bat_capacity}" -lt "${THRESHOLD_3}" ] &&\
                echo "${STATUS_6}" && return 0
            [ "${bat_capacity}" -lt "${THRESHOLD_4}" ] &&\
                echo "${STATUS_5}" && return 0
            echo "${STATUS_4}" && return 0
        ;;
        *) echo "${STATUS_9}" && return 0;;
    esac
}

render_icon () {
    case "${1}" in
        "${STATUS_1}") echo "${ICON_1}";;
        "${STATUS_2}") echo "${ICON_2}";;
        "${STATUS_3}") echo "${ICON_3}";;
        "${STATUS_4}") echo "${ICON_4}";;
        "${STATUS_5}") echo "${ICON_5}";;
        "${STATUS_6}") echo "${ICON_6}";;
        "${STATUS_7}") echo "${ICON_7}";;
        "${STATUS_8}") echo "${ICON_8}";;
        "${STATUS_9}") echo "${ICON_9}";;
    esac
}

refresh () {(
    # If the function has [1-9] as first parameter,
    # Show the mock scenario instead of actual battery status
    case "${1}" in
        "1") # Mock Scenario 1: Full
            bat_status="Full"
            capacity="100";;
        "2") # Mock Scenario 2: Charging
            bat_status="Charging"
            capacity="95";; # Threshold: 15 30 70 90
        "3") # Mock Scenario 3: NotCharging
            bat_status="Notcharging"
            capacity="95";;
        "4") # Mock Scenario 4: Discharging VeryHigh (90~)
            bat_status="Discharging"
            capacity="95";;
        "5") # Mock Scenario 5: Discharging High (70~89)
            bat_status="Discharging"
            capacity="75";;
        "6") # Mock Scenario 6: Discharging Middle (30~69)
            bat_status="Discharging"
            capacity="35";;
        "7") # Mock Scenario 7: Discharging Low (15~29)
            bat_status="Discharging"
            capacity="25";;
        "8") # Mock Scenario 8: Discharging VeryLow (~15)
            bat_status="Discharging"
            capacity="14";;
        "9") # Mock Scenario 9: Unknown
            bat_status=""
            bat_capacity="";;
        *) # Actual Battery Info
            bat_status=$(info ${BAT_NAME} "status" | tr -d ' ')
            capacity=$(info ${BAT_NAME} "capacity");;
    esac

    status=$(get_status ${bat_status} ${capacity})
    visible="true"

    [ "${HIDE_ON_UNKNOWN}" = "true" ] &&\
    [ "${status}" = "${STATUS_9}" ] &&\
        visible="false"

    [ "${HIDE_ON_FULL}" = "true" ] &&\
    [ "${status}" = "${STATUS_1}" ] &&\
        visible="false"

    export capacity
    export status
    export visible
    export icon=$(render_icon ${status})

    echo ${RENDER_FMT} | envsubst
)}

main () {
    parse_config
    refresh
}

main
