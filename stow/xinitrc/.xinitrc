xmodmap -e 'keycode 105 = Hangul_Hanja'
xmodmap -e 'keycode 108 = Hangul'
xmodmap -e 'remove mod1 = Hangul'
xmodmap -e 'remove control = Hangul_Hanja'
export GTK_IM_MODULE=nimf
export QT4_IM_MODULE="nimf"
export QT_IM_MODULE=nimf
export XMODIFIERS="@im=nimf"
nimf &
# exec i3
exec bspwm
