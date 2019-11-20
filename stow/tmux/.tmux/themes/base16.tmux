#!/bin/bash

# ============================================================================
#
# Tmux statusbar theme for base16 colorscheme
#
#   Author:
#       - Piu Tranquillo (https://github.com/piutranq)
#
#   Require:
#       - Nerd font (Author uses UbuntuMono NF)
#           (https://github.com/ryanoasis/nerd-fonts)
#       - tmux-prefix-highlight (if uses ${seg_prefix})
#           (https://github.com/tmux-plugins/tmux-prefix-highlight)
#       - tumx-battery (if uses ${seg_battery})
#           (https://github.com/tmux-plugins/tmux-battery)
#       - tmux-online-status (if uses ${seg_online})
#           (https://github.com/tmux-plugins/tmux-online-status)
#
# ============================================================================

# Color Redirection
co_black="black"
co_blue="blue"
co_yellow="yellow"
co_red="red"
co_white="white"
co_green="green"
co_grey="brightblack"
co_comment="brightblack"

co_brightblack="brightblack"
co_brightred="brightred"
co_brightgreen="brightgreen"
co_brightyellow="brightyellow"
co_brightblue="brightblue"
co_brightpurple="brightpurple"
co_brightcyan="brightcyan"
co_brightwhite="brightwhite"

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

# Darker text when panes and windows are inactive
set "window-style" "fg=$co_grey,bg=default"
set "window-active-style" "fg=$co_white,bg=default"

# Pane border color
set "pane-border-style" "fg=$co_grey,bg=default"
set "pane-active-border-style" "fg=white"

set "display-panes-active-colour" "$co_yellow"
set "display-panes-colour" "$co_grey"

# Default of status bar
set "status-bg" "$co_black"
set "status-fg" "$co_white"

# Plugin: prefix_highlight
seg_prefix="#{prefix_highlight}"
set "@prefix_highlight_empty_has_affixes" "off"
set "@prefix_highlight_empty_attr" ""
set "@prefix_highlight_show_copy_mode" "on"
set "@prefix_highlight_empty_prompt" "    "
set "@prefix_highlight_prefix_prompt" "    "
set "@prefix_highlight_copy_prompt" "    "
set "@prefix_highlight_output_prefix" "#[]"
set "@prefix_highlight_output_suffix" "#[]"

# Time & date segment
date_format=$(get "@date_format" "%y-%m-%d %a")
time_format=$(get "@time_format" "%R")
seg_timedate="${fb_reset} ${date_format} / ${time_format} ${fb_reset}"

# Plugin: tmux-battery

## segment
seg_battery="#{battery_color_bg}#{battery_color_fg} #{battery_icon} #{battery_percentage} ${fb_reset}"

## status icons
set "@batt_icon_status_charged" "  "
set "@batt_icon_status_charging" "  "
set "@batt_icon_status_unknown" " "

## charge icons
set "@batt_icon_charge_tier8" "  " # 95% ~
set "@batt_icon_charge_tier7" "  " # 80% ~
set "@batt_icon_charge_tier6" "  " # 65% ~
set "@batt_icon_charge_tier5" "  " # 50% ~
set "@batt_icon_charge_tier4" "  " # 35% ~
set "@batt_icon_charge_tier3" "  " # 20% ~
set "@batt_icon_charge_tier2" "  " # 5% ~
set "@batt_icon_charge_tier1" "  " # 0% ~

## charge colors (fg)
set "@batt_color_charge_primary_tier8" "$co_white"
set "@batt_color_charge_primary_tier7" "$co_white"
set "@batt_color_charge_primary_tier6" "$co_white"
set "@batt_color_charge_primary_tier5" "$co_white"
set "@batt_color_charge_primary_tier4" "$co_white"
set "@batt_color_charge_primary_tier3" "$co_white"
set "@batt_color_charge_primary_tier2" "$co_white"
set "@batt_color_charge_primary_tier1" "$co_black"

## charge colors (bg)
set "@batt_color_charge_secondary_tier8" "$co_black"
set "@batt_color_charge_secondary_tier7" "$co_black"
set "@batt_color_charge_secondary_tier6" "$co_black"
set "@batt_color_charge_secondary_tier5" "$co_black"
set "@batt_color_charge_secondary_tier4" "$co_black"
set "@batt_color_charge_secondary_tier3" "$co_black"
set "@batt_color_charge_secondary_tier2" "$co_black"
set "@batt_color_charge_secondary_tier1" "$co_red"

## status colors (fg)
set "@batt_color_status_primary_charged" "$co_white"
set "@batt_color_status_primary_charging" "$co_black"
set "@batt_color_status_primary_unknown" "$co_grey"

## status colors (bg)
set "@batt_color_status_secondary_charged" "$co_black"
set "@batt_color_status_secondary_charging" "$co_green"
set "@batt_color_status_secondary_unknown" "$co_white"


# Plugin: tmux-online-status
seg_online="#{online_status}"
set "@online_icon" "#[fg=$co_white,bg=$co_black]   ${fb_reset}"
set "@offline_icon" "#[fg=$co_black,bg=$co_red]   ${fb_reset}"


# status-right
set "status-right-length" "60"
set "status-right" "${seg_prefix}${seg_online}${seg_timedate}${seg_battery}"

# status-left
session_segment="#[bold] Session ###S${fb_reset}"
set "status-left-length" "60"
set "status-left" "${session_segment} "

set "window-status-format" "
#[fg=$co_grey,bg=$co_black,nobold] #W ${fb_reset}"

set "window-status-current-format" "
#[fg=$co_white,bg=$co_blue,bold] #W ${fb_reset}"

