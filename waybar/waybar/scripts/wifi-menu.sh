#!/bin/bash

# A simple script to display and connect to WiFi networks using nmcli and rofi/wofi

# Determine which menu program to use (wofi for Wayland, rofi for X11)
# Forcing rofi for this example, adjust if needed
MENU_CMD="rofi -dmenu -i -p WiFi -theme catppuccin-mocha" # Added theme

# Get a list of available WiFi networks, show BARS, SSID, SECURITY
NETWORKS=$(nmcli -f SSID,BARS,SECURITY dev wifi list | sed '/^--/d' | tail -n +2 | sed 's/^\s*//' | sed 's/\s\s\+/\t/g') # Tab separated for cleaner awk

# Show the menu and get the chosen network
CHOSEN_LINE=$(echo -e "$NETWORKS" | $MENU_CMD)

# If a network was chosen, extract the SSID
if [ -n "$CHOSEN_LINE" ]; then
  SSID=$(echo "$CHOSEN_LINE" | awk -F'\t' '{print $1}') # Get SSID (first column)
  
  # Check if the SSID is already known (existing connection profile)
  if nmcli -t -f NAME c show | grep -q "^$SSID$"; then
    # Connect to known network
    nmcli c up "$SSID"
  else
    # For new networks, ask for a password if needed (based on security in chosen line)
    if echo "$CHOSEN_LINE" | grep -q -E "WPA|WEP"; then
      PASSWORD=$(echo "" | rofi -dmenu -p "Password for $SSID:" -password -theme catppuccin-mocha)
      if [ -n "$PASSWORD" ]; then
        nmcli dev wifi connect "$SSID" password "$PASSWORD"
      fi
    else
      # For open networks
      nmcli dev wifi connect "$SSID"
    fi
  fi
fi
