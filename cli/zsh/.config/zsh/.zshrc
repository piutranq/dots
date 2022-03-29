
# $ZDOTDIR/.zshrc
# ==================================================================

# Check the running shell is `zsh`: If not, don't do anything.
[ $(ps -o comm -p $$ | grep 'zsh') ] && [ ! -z $(echo $ZSH_VERSION) ] || return 0

# Ensure the $ZDOTDIR path
ZDOTDIR=${ZDOTDIR:-$HOME}

# Zinit config
## Zinit Path
declare -A ZINIT
ZINIT[HOME_DIR]="${XDG_DATA_HOME:-"$HOME/.local/share"}/zinit"
ZINIT[BIN_DIR]="${ZINIT[HOME_DIR]}/bin"
ZINIT[ZCOMPDUMP_PATH]="${XDG_CACHE_HOME:-"$HOME/.cache"}/zcompdump-${HOST}-${ZSH_VERSION}"

## Load Zinit
if [[ ! -f "${ZINIT[BIN_DIR]}/zinit.zsh" ]]; then
    print -P "%F{15}%BInstalling zinit...%f%b"
    mkdir -p "${ZINIT[HOME_DIR]}" && chmod g-rwX "${ZINIT[HOME_DIR]}"
    git clone https://github.com/z-shell/zinit "${ZINIT[BIN_DIR]}" && \
        print -P "%F{10}%BInstallation successful.%f%b"|| \
        print -P "%F{9}%BFailed to clone zinit%f%b"
fi
source "${ZINIT[BIN_DIR]}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

## Load Plugins
zinit snippet OMZL::clipboard.zsh
zinit snippet OMZL::termsupport.zsh
zinit snippet OMZL::git.zsh
zinit snippet OMZL::key-bindings.zsh
zinit snippet OMZL::directories.zsh

zinit wait lucid light-mode for \
    atinit'zicompinit; zicdreplay' \
        z-shell/fast-syntax-highlighting \
    atload'_zsh_autosuggest_start' \
        zsh-users/zsh-autosuggestions \
    blockf atpull'zinit creinstall -q .' \
        zsh-users/zsh-completions

# Prompt config
## Set the zsh theme
ZSH_THEME="lambda"

## The path contains zsh theme file
ZTHEMEDIR="$ZDOTDIR/.zsh-themes"

## Enable the zsh color definitions
## The `colors` function should be called before the theme is loaded.
autoload -U colors && colors

## Source theme file
## Some suffixes (extensions) are enabled: ".zsh" or ".zsh-theme"
## Sourcing theme file should be after OMZL::git.zsh is loaded
source "$ZTHEMEDIR/$ZSH_THEME" 2>/dev/null || \
source "$ZTHEMEDIR/$ZSH_THEME.zsh" 2>/dev/null || \
source "$ZTHEMEDIR/$ZSH_THEME.zsh-theme" 2>/dev/null

## Enable the prompt string is expansible
setopt prompt_subst

# History config
## History file configuration
HISTFILE="${XDG_CACHE_HOME:-"$HOME/.cache"}/.zhist"
[ $HISTSIZE -lt 10000 ] && HISTSIZE=10000
[ $SAVEHIST -lt 2000 ] && SAVEHIST=2000
## History command configuration
setopt extended_history
setopt hist_expire_dups_first
setopt hist_find_no_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt share_history

# Aliases
## If it is possible, replace `ls` to `exa`
[[ -x "$(which exa)" ]] && alias ls='exa --group-directories-first'
## and some aliases of ls(exa)
alias la='ls -lah'
alias l='ls -lah'
alias ll='ls -lh'

# vim:wrap!
