#!/bin/bash

MENU_CMD="rofi -dmenu -i -p Power -theme catppuccin-mocha -lines 5 -width 20"

# For Sway/Hyprland, replace with respective commands if different
# Ensure your user can execute shutdown/reboot, possibly via sudoers
LOGOUT_CMD="loginctl terminate-user $(whoami)" # Generic systemd logout
SHUTDOWN_CMD="systemctl poweroff"
REBOOT_CMD="systemctl reboot"
SUSPEND_CMD="systemctl suspend"
LOCK_CMD="swaylock" # Replace with your preferred screen locker (e.g., hyprlock)

options="󰌾 Lock\n󰍃 Logout\n󰑐 Reboot\n Shutdown\n󰒲 Suspend"
# Icons: nf-md-lock, nf-md-logout, nf-md-restart, nf-fa-power_off, nf-md-sleep

chosen=$(echo -e "$options" | $MENU_CMD)

case "$chosen" in
    *"Lock") $LOCK_CMD ;;
    *"Logout") $LOGOUT_CMD ;;
    *"Reboot") $REBOOT_CMD ;;
    *"Shutdown") $SHUTDOWN_CMD ;;
    *"Suspend") $SUSPEND_CMD ;;
esac
