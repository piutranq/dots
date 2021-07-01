#!/usr/bin/env sh

readonly COLOR_INI="${XDG_CONFIG_HOME:-"${HOME}/.config"}/polybar/color"

parse_color() {
    awk '/^\[.*\]$/{obj=$0}/=/{print obj $0}' ${COLOR_INI} \
    | tr -d ' ' | grep "\[color\]$1" | awk -F'=' '{print $2}'
}

export COLOR_EMPTY="$(parse_color "empty")"
export COLOR_BACKGROUND="$(parse_color "background")"
export COLOR_FOREGROUND="$(parse_color "foreground")"

export COLOR_GREY0="$(parse_color "grey0")"
export COLOR_GREY1="$(parse_color "grey1")"
export COLOR_GREY2="$(parse_color "grey2")"
export COLOR_GREY3="$(parse_color "grey3")"
export COLOR_GREY4="$(parse_color "grey4")"
export COLOR_GREY5="$(parse_color "grey5")"

export COLOR_RED="$(parse_color "red")"
export COLOR_GREEN="$(parse_color "green")"
export COLOR_YELLOW="$(parse_color "yellow")"
export COLOR_BLUE="$(parse_color "blue")"
export COLOR_MAGENTA="$(parse_color "magenta")"
export COLOR_CYAN="$(parse_color "cyan")"

