#!/bin/sh

# Add $PATH
addpath(){
  for ARG in "$@"
  do
    export PATH="$ARG:$PATH"
  done
}

addpath "$HOME/.cargo/bin"
addpath "$HOME/.local/bin"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"

# set cologen-refresh path
export COLOGEN_REFRESH_CONFIG="$XDG_CONFIG_HOME/cologen-refresh"
export COLOGEN_REFRESH_CACHE="$XDG_CACHE_HOME/cologen-refresh"

# Set default editor
export EDITOR=nvim
