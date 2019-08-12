#!/usr/bin/env bash

# Theme
$HOME/.fehbg
xsetroot -cursor_name left_ptr

# Keymapping & IME
xmodmap -e 'keycode 105 = Hangul_Hanja'
xmodmap -e 'keycode 108 = Hangul'
xmodmap -e 'remove mod1 = Hangul'
xmodmap -e 'remove control = Hangul_Hanja'
export GTK_IM_MODULE=nimf
export QT4_IM_MODULE="nimf"
export QT_IM_MODULE=nimf
export XMODIFIERS="@im=nimf"
nimf &

# Autostart WM Independent daemons
dropbox-cli start
compton &
$XDG_CONFIG_HOME/dunst/scripts/launch.sh
$XDG_CONFIG_HOME/sxhkd/scripts/launch.sh

# Start WM
exec bspwm

