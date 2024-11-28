# $ZDOTDIR/.zshrc
# ==================================================================

# Check the running shell is `zsh`: If not, don't do anything.
[ $(ps -o comm -p $$ | grep 'zsh') ] && [ ! -z $(echo $ZSH_VERSION) ] || return 0

# Ensure the $ZDOTDIR path
ZDOTDIR=${ZDOTDIR:-$HOME}

# Source individual config files
source "$ZDOTDIR/zi.zsh" # Plugin Manager ("z-shell/zi")
source "$ZDOTDIR/history.zsh"
source "$ZDOTDIR/alias.zsh"

# vim:wrap!
