#!/bin/bash

# A simple script to display and connect to WiFi networks using nmcli and rofi/wofi

# Determine which menu program to use (wofi for Wayland, rofi for X11)
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
  MENU="wofi -d -i"
else
  MENU="rofi -dmenu -i"
fi

# Get a list of available WiFi networks
NETWORKS=$(nmcli -f SSID,BARS,SECURITY dev wifi list | tail -n +2 | sed 's/^ *//')

# Show the menu and get the chosen network
CHOSEN=$(echo "$NETWORKS" | $MENU -p "WiFi Networks:")

# If a network was chosen, extract the SSID
if [ -n "$CHOSEN" ]; then
  SSID=$(echo "$CHOSEN" | awk '{print $1}')
  
  # Check if the SSID is already known
  if nmcli -t -f NAME c show | grep -q "^$SSID$"; then
    # Connect to known network
    nmcli c up "$SSID"
  else
    # For new networks, ask for a password if needed
    if echo "$CHOSEN" | grep -q -E "WPA|WEP"; then
      PASSWORD=$(echo "" | $MENU -p "Password for $SSID:")
      if [ -n "$PASSWORD" ]; then
        nmcli dev wifi connect "$SSID" password "$PASSWORD"
      fi
    else
      # For open networks
      nmcli dev wifi connect "$SSID"
    fi
  fi
fi
