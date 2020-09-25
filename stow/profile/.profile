#!/bin/sh

# Add $PATH
function addpath() {
  for ARG in "$@"; do
    export PATH="$ARG:$PATH"
  done
}

addpath "$HOME/.cargo/bin"
addpath "$HOME/.local/bin"
unset -f addpath

# Set XDG Base directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"

# Set cologen-refresh path
export COLOGEN_REFRESH_CONFIG="$XDG_CONFIG_HOME/cologen-refresh"
export COLOGEN_REFRESH_CACHE="$XDG_CACHE_HOME/cologen-refresh"

# Set default editor
export EDITOR=nvim
