#!/bin/bash

# ============================================================================
#
# Tmux statusbar theme for base16 colorscheme
#
#   Author:
#       - Piu Tranquillo (https://github.com/piutranq)
#
#   Based on:
#       - odedlaz/tmux-onedark-theme
#           (https://github.com/odelaz/tmux-onedark-theme)
#
#   Require:
#       - Nerd font (Author uses UbuntuMono NF)
#           (https://github.com/ryanoasis/nerd-fonts)
#       - tmux-prefix-highlight
#           (https://github.com/tmux-plugins/tmux-prefix-highlight)
#       - tumx-battery (if uses #{$battery_segment})
#           (https://github.com/tmux-plugins/tmux-battery)
#       - tmux-online-status (if uses #{$online_segment})
#           (https://github.com/tmux-plugins/tmux-online-status)
#
# ============================================================================

# TTY Color
co_black="black"
co_blue="blue"
co_yellow="yellow"
co_red="red"
co_white="white"
co_green="green"
co_grey="brightblack"
co_comment="brightblack"

# Color Alias
fg_reset="#[fg=$co_white]"
bg_reset="#[bg=$co_black]"
fb_reset="#[fg=$co_white,bg=$co_black]"

get() {
   local option=$1
   local default_value=$2
   local option_value="$(tmux show-option -gqv "$option")"

   if [ -z "$option_value" ]; then
      echo "$default_value"
   else
      echo "$option_value"
   fi
}

set() {
   local option=$1
   local value=$2
   tmux set-option -gq "$option" "$value"
}

setw() {
   local option=$1
   local value=$2
   tmux set-window-option -gq "$option" "$value"
}

# Status bar position
set "status" "on"
set "status-position" "top"
set "status-justify" "left"

# Message color
set "message-fg" "$co_white"
set "message-bg" "$co_black"
set "message-command-fg" "$co_white"
set "message-command-bg" "$co_black"

set "status-attr" "none"
set "status-left-attr" "none"
set "status-right-attr" "none"

setw "window-status-fg" "$co_black"
setw "window-status-bg" "$co_black"
setw "window-status-attr" "none"

setw "window-status-activity-bg" "$co_black"
setw "window-status-activity-fg" "$co_black"
setw "window-status-activity-attr" "none"

setw "window-status-separator" " "

# Darker text when panes and windows are inactive
set "window-style" "fg=$co_comment,bg=default"
set "window-active-style" "fg=$co_white,bg=default"

# Pane border color
set "pane-border-bg" "default"
set "pane-border-fg" "$co_black"
set "pane-active-border-bg" "default"
set "pane-active-border-fg" "$co_comment"

set "display-panes-active-colour" "$co_yellow"
set "display-panes-colour" "$co_blue"

# Default of status bar
set "status-bg" "$co_black"
set "status-fg" "$co_white"

# Plugin: prefix_highlight
set "@prefix_highlight_empty_has_affixes" "off"
set "@prefix_highlight_empty_attr" ""
set "@prefix_highlight_show_copy_mode" "on"
set "@prefix_highlight_empty_prompt" "    "
set "@prefix_highlight_prefix_prompt" "    "
set "@prefix_highlight_copy_prompt" "    "
set "@prefix_highlight_output_prefix" "#[]"
set "@prefix_highlight_output_suffix" "#[]"

# timedate_segment
date_format=$(get "@date_format" "%y-%m-%d %a")
time_format=$(get "@time_format" "%R")
timedate_segment="${date_format} / ${time_format}"

# Plugin: tmux-battery
set "@batt_charged_icon" "#[fg=$co_white]  "
set "@batt_charging_icon" "#[fg=$co_green]  "
set "@batt_full_charge_icon" "#[fg=$co_white]  "
set "@batt_high_charge_icon" "#[fg=$co_white]  "
set "@batt_medium_charge_icon" "#[fg=$co_yellow]  "
set "@batt_low_charge_icon" "#[fg=$co_red]  "
battery_segment=" #{battery_icon} #{battery_percentage}${fb_reset}"

# Plugin: tmux-online-status
set "@online_icon" " "
set "@offline_icon" "#[fg=$co_grey] ${fb_reset}"
online_segment="#{online_status}"

userhost_segment="#[fg=$co_green,bold]λ #[fg=$co_yellow,bold]#h"

session_segment="#[bold] Session ###S${fb_reset}"

# status-right
set "status-right-length" "60"
set "status-right" "
#{prefix_highlight} ${online_segment} ${timedate_segment} ${battery_segment} 
"
# status-left
set "status-left-length" "60"
set "status-left" "${session_segment} "

set "window-status-format" "
#[fg=$co_grey,bg=$co_black,nobold] #I "

set "window-status-current-format" "
#[fg=$co_white,bg=$co_blue,bold] #I ${fb_reset}"

