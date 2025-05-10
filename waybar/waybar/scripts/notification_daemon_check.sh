#!/bin/bash

ICON_ON="󰂚" # Nerd Font: nf-md-bell
ICON_OFF="󰂛" # Nerd Font: nf-md-bell_off
ERROR_ICON="OnError parsing notification daemon check script." # Nerd Font: nf-md-bell_alert

# Attempt to get the count, redirect stderr to /dev/null if dunstctl fails silently
COUNT_OUTPUT=$(dunstctl count history 2>/dev/null)

# Check if dunstctl command was successful and output is a number
if [[ $? -eq 0 ]] && [[ "$COUNT_OUTPUT" =~ ^[0-9]+$ ]]; then
  COUNT=$COUNT_OUTPUT
  if [ "$COUNT" -gt 0 ]; then
    echo "{\"text\":\"$ICON_ON $COUNT\", \"tooltip\":\"$COUNT notifications\", \"class\":\"has-notifications\"}"
  else
    echo "{\"text\":\"$ICON_OFF\", \"tooltip\":\"No notifications\", \"class\":\"no-notifications\"}"
  fi
else
  # Dunstctl failed or didn't return a number
  echo "{\"text\":\"$ERROR_ICON\", \"tooltip\":\"Dunst not running or error\", \"class\":\"has-error\"}"
fi
