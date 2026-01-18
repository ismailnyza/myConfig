#!/bin/bash

# Get notification count from SwayNotificationCenter if it's installed
if command -v swaync-client &> /dev/null; then
  count=$(swaync-client -c)
  
  # Format the output as JSON for Waybar
  if [ "$count" -gt 0 ]; then
    echo "{\"text\":\"󰂚\", \"tooltip\":\"$count notifications\", \"class\":\"has-notifications\"}"
  else
    echo "{\"text\":\"󰂚\", \"tooltip\":\"No notifications\", \"class\":\"no-notifications\"}"
  fi
else
  # Fallback if swaync-client is not installed
  echo "{\"text\":\"󰂚\", \"tooltip\":\"SwayNotificationCenter not installed\", \"class\":\"no-notifications\"}"
fi
