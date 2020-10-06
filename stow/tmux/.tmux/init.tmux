#!/usr/bin/env bash
[[ -n "$TMUX" ]] && {

    declare -r TMUXDIR="$(realpath -s $(dirname "${BASH_SOURCE[0]}" ))"

    source $TMUXDIR/config/options
    source $TMUXDIR/config/keybindings
    source $TMUXDIR/config/statusbar/main
    source $TMUXDIR/config/style

}
