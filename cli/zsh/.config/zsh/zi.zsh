# $ZDOTDIR/zi.zsh
# ==================================================================

# Ensure the $ZDOTDIR path
ZDOTDIR=${ZDOTDIR:-$HOME}

## Zi Path
declare -A ZI
ZI[HOME_DIR]="${XDG_DATA_HOME:-"$HOME/.local/share"}/zi"
ZI[BIN_DIR]="${ZI[HOME_DIR]}/bin"
ZI[ZCOMPDUMP_PATH]="${XDG_CACHE_HOME:-"$HOME/.cache"}/.zcompdump-${HOST}-${ZSH_VERSION}"

## Install & Load Zi
if [[ ! -f "${ZI[BIN_DIR]}/zi.zsh" ]]; then
    print -P "%F{15}%BInstalling zi...%f%b"
    mkdir -p "${ZI[HOME_DIR]}" && chmod g-rwX "${ZI[HOME_DIR]}"
    git clone https://github.com/z-shell/zi "${ZI[BIN_DIR]}" && \
        print -P "%F{10}%BInstalled successful.%f%b"|| \
        print -P "%F{9}%BFailed to clone zi%f%b"
fi
source "${ZI[BIN_DIR]}/zi.zsh"
autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi

## Disable async-prompt before load OMZL::git.zsh
### Fix the issue #12328 (https://github.com/ohmyzsh/ohmyzsh/issues/12328)
zstyle ':omz:alpha:lib:git' async-prompt false

## Load Snippets
zi snippet OMZL::functions.zsh
zi snippet OMZL::clipboard.zsh
zi snippet OMZL::termsupport.zsh
zi snippet OMZL::git.zsh
zi snippet OMZL::key-bindings.zsh
zi snippet OMZL::directories.zsh

## Load Plugins
zi wait lucid light-mode for \
    atinit'zicompinit; zicdreplay' \
        z-shell/F-Sy-H \
    atload'_zsh_autosuggest_start' \
        zsh-users/zsh-autosuggestions \
    blockf atpull'zi creinstall -q .' \
        zsh-users/zsh-completions

## Setup OMZ Theme
## Set default OMZ Theme
ZSH_THEME=${ZSH_THEME:-"lambda"}

## Enable the zsh color definitions
## The `colors` function should be called before the theme is loaded.
autoload -U colors && colors

## Source theme file
## Some suffixes (extensions) are enabled: ".zsh" or ".zsh-theme"
## Sourcing theme file should be after OMZL::git.zsh is loaded
OMZ_THEME_DIR="$ZDOTDIR/omz-themes"
source "$OMZ_THEME_DIR/$ZSH_THEME" 2>/dev/null || \
source "$OMZ_THEME_DIR/$ZSH_THEME.zsh" 2>/dev/null || \
source "$OMZ_THEME_DIR/$ZSH_THEME.zsh-theme" 2>/dev/null

## Enable the prompt string is expansible
setopt prompt_subst

# vim:wrap!
