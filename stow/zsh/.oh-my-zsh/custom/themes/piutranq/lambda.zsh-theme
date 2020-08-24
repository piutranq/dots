#!/usr/bin/env zsh

# piutranq/lambda, the oh-my-zsh theme used by piutranq.
# ============================================================================
#   Based on halfo/lambda-mod-zsh-theme
#       (https://github.com/halfo/lambda-mod-zsh-theme)
#   Modified by piutranq
#       (https://github.com/piutranq)
#
#   The theme used some non-ascii iconic character.
#   "Iosevka" font is compatible with the theme.
#       (https://github.com/be5invis/Iosevka)
# ============================================================================

function get_left_prompt() {
    # Define Frequently Used Colors
    local COLOR_RESET="%{$reset_color%}"

    # Get PROMPT_EXIT
    local COLOR_EXIT="%(?,%{$fg_bold[green]%},%{$fg_bold[red]%})"
    local PROMPT_EXIT="${COLOR_EXIT}λ${COLOR_RESET}"

    # Get PROMPT_USERHOST
    local COLOR_USER
    [[ "$USER" == "root" ]]\
        && COLOR_USER="%{$fg_bold[red]%}"\
        || COLOR_USER="%{$fg_bold[yellow]%}"
    local PROMPT_USERHOST="${COLOR_USER}%n${COLOR_RESET}@${COLOR_USER}%m"

    # Get PROMPT_PWD
    local PROMPT_PWD="%{$fg_no_bold[magenta]%}[%3~]$COLOR_RESET"

    # Get PROMPT_GIT
    # If the working directory is git repository
    if git rev-parse --git-dir > /dev/null 2>&1; then
        local PROMPT_GIT="$(git_prompt_info 2> /dev/null) $(git_prompt_status)"
        # If the working directory is detached-head state
        if ! [[ $(git symbolic-ref -q HEAD) ]]; then
            local PROMPT_DETACHED="%{$fg[blue]%}(detached-head)${COLOR_RESET}"
            PROMPT_GIT="${PROMPT_DETACHED} ${PROMPT_GIT}"
        fi
    else
        PROMPT_GIT=""
    fi

    # Get PROMPT_CARET
    local PROMPT_CARET="%{$fg_bold[cyan]%}≫${COLOR_RESET}"

    # Print
    echo "${PROMPT_EXIT} ${PROMPT_USERHOST} ${PROMPT_PWD} ${PROMPT_GIT}"
    echo -n "${PROMPT_CARET} "
}

function get_right_prompt() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        echo -n "$(git_prompt_short_sha)%{$reset_color%}"
    else
        echo -n "%{$reset_color%}"
    fi
}

PROMPT='$(get_left_prompt)'
RPROMPT='$(get_right_prompt)'

# Format for git_prompt_info()
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%} "
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
