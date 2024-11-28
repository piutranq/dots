# $ZDOTDIR/history.zsh
# ==================================================================

# Ensure Paths (ZDOTDIR, XDG)
XDG_CACHE_HOME="${XDG_CACHE_HOME:-"$HOME/.cache"}"

## History
HISTFILE="${XDG_CACHE_HOME}/.zhist"
[ $HISTSIZE -lt 10000 ] && HISTSIZE=10000
[ $SAVEHIST -lt 2000 ] && SAVEHIST=2000
setopt extended_history
setopt hist_expire_dups_first
setopt hist_find_no_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt share_history

# vim:wrap!
