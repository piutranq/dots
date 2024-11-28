# $ZDOTDIR/alias.zsh
# ==================================================================

## ls -> eza
[[ -x "$(which eza)" ]] && alias ls='eza --group-directories-first'

## ls variations
alias la='ls -lah'
alias l='ls -lah'
alias ll='ls -lh'

# vim:wrap!
