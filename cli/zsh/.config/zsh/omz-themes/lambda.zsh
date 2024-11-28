# lambda, the ohmyzsh theme customed by piutranq
# =========================================================================
#   Based on halfo/lambda-mod-zsh-theme
#       (https://github.com/halfo/lambda-mod-zsh-theme)
#   Modified by piutranq
#       (https://github.com/piutranq)
#
#   The theme used some non-ascii iconic character.
#   "Iosevka" font is compatible with the theme.
#       (https://github.com/be5invis/Iosevka)
#
#   Required for using with manual sourcing
#       - `/lib/git.zsh` from ohmyzsh (https://github.com/ohmyzsh/ohmyzsh)
# =========================================================================

# Check the running shell is `zsh`: If not, don't do anything.
[ $(ps -o comm -p $$ | grep 'zsh') ] && [ ! -z $(echo $ZSH_VERSION) ] || return 0

# Ensure the required configurations
autoload -U colors && colors # Enable the zsh color definitions.
setopt prompt_subst          # Enable the prompt string is expansible.

function get_ps1() {
    local FMT_EXIT="%(?.%{$fg_bold[green]%}.%{$fg_bold[red]%})"
    local FMT_USER="%(!.%{$fg_bold[red]%}.%{$fg_bold[yellow]%})"
    local FMT_PROMPT="%{$fg_no_bold[magenta]%}"

    local PROMPT_EXIT="${FMT_EXIT}λ"
    local PROMPT_USERHOST="${FMT_USER}%n%{$reset_color%}@${FMT_USER}%m"
    local PROMPT_PWD="${FMT_PROMPT}[%3~]"

    if git rev-parse --git-dir > /dev/null 2>&1; then
        local PROMPT_GIT="$(git_prompt_info 2>/dev/null) $(git_prompt_status)"
        if ! [[ $(git symbolic-ref -q HEAD) ]]; then
            local PROMPT_DETACHED="%{$fg_no_bold[blue]%}(detached-head)"
            PROMPT_GIT="${PROMPT_DETACHED} ${PROMPT_GIT}"
        fi
    else
        PROMPT_GIT="%{$reset_color%}"
    fi

    echo "$PROMPT_EXIT $PROMPT_USERHOST $PROMPT_PWD $PROMPT_GIT %{$reset_color%}"
    echo -n "%{$fg_bold[cyan]%}≫ %{$reset_color%}"
}

function get_ps2() {
    echo -n "%{$fg_bold[red]%}≫ %{$reset_color%}    "
}

function get_rprompt() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        echo -n "$(git_prompt_short_sha)%{$reset_color%}"
    fi
    echo -n "%{$reset_color%}"
}

PROMPT='$(get_ps1)'
PROMPT2='$(get_ps2)'
RPROMPT='$(get_rprompt)'

# Format for git_prompt_info()
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_no_bold[blue]%} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%} ✔ "

# Format for git_prompt_status()
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg_bold[green]%}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[blue]%}!"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%}-"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg_bold[magenta]%}>"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[yellow]%}#"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[cyan]%}?"

# Format for git_prompt_ahead()
ZSH_THEME_GIT_PROMPT_AHEAD=" %{$fg_bold[white]%}^"

# Format for git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=" %{$fg_bold[white]%}[%{$fg_bold[blue]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$fg_bold[white]%}]"

# vim:ft=zsh
# vim:wrap!
