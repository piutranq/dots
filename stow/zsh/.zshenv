
# $HOME/.zshenv
# ==================================================================
# `.zshenv` should be placed at `$HOME`, not `$ZDOTDIR`.
#
# Because if no startup file are placed in $HOME and $ZDOTDIR is set
# on `/etc/zshenv` only, zsh will be ask to write the new zshrc file
# at `$HOME/.zshrc`.
# ==================================================================

ZDOTDIR=$HOME/.config/zsh

