# $ZDOTDIR/.zprofile
# ==================================================================

# XDG Base Directory
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-"$HOME/.cache"}
export XDG_DATA_HOME=${XDG_DATA_HOME:-"$HOME/.local/share"}

# Path Appends
path+="$HOME/.local/bin"
path+="$HOME/.cargo/bin"
path+="$HOME/.bun/bin"
typeset -U path # remove dups

# Default Apps
[[ -x $(which nvim) ]] && \
    export EDITOR=nvim && \
    export VISUAL=nvim

