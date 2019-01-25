#!/bin/sh

# Start xorg-independent daemons
dropbox-cli start &> /dev/null 2>&1

# Add $PATH
addpath(){
  for ARG in "$@"
  do
    export PATH="$ARG:$PATH"
  done
}

addpath "$HOME/.scripts"                # Custom scripts
addpath "$HOME/.nodejs/selected/bin"    # NodeJS

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
