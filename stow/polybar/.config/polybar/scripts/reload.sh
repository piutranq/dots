#!/usr/bin/env bash
wait_for_launch () {
    while [ ! $(find /tmp/polybar_mqueue.*) ]; do sleep 0.1; done
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
    is_launched && reload-all || launch-all
    wait_for_launch
}

#main >/dev/null 2>&1
main
