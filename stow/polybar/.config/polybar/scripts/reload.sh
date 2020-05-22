#!/usr/bin/env bash
wait_for_launch () {
    while [ ! $(find /tmp/polybar_mqueue.*) ]; do sleep 0.1; done
}

check_device_specific () {
    local -r DEV_LINKNAME="$XDG_CONFIG_HOME/polybar/device-specific/current"
    local -r DEV_TARGET="$XDG_CONFIG_HOME/polybar/device-specific/$(hostname)"
    [ -r $DEV_LINKNAME ] || ln -sf -T "$DEV_TARGET" -- "$DEV_LINKNAME"
}

launch-all () {
    polybar top &
}

reload-all () {
    polybar-msg cmd restart
}

is_launched () {
    $(pgrep -u $UID -x polybar > /dev/null)
}

main () {
    check_device_specific
    is_launched && reload-all || launch-all
    wait_for_launch
}

main >/dev/null 2>&1
