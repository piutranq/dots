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
