#!/bin/bash

VPN_INTERFACE="tun0" # Common for OpenVPN, **ADJUST IF NEEDED**
VPN_INTERFACE_WG="wg0" # Common for WireGuard, **ADJUST IF NEEDED**
# VPN_SERVICE_NAME="your-vpn-service-name" # Alternative check

ICON_ON="" # Lock icon (VPN On) - nf-fa-lock
ICON_OFF="" # Unlocked icon (VPN Off) - nf-fa-unlock
TEXT_ON="VPN"
TEXT_OFF="VPN Off"
CLASS_ON="vpn-on"
CLASS_OFF="vpn-off"

CURRENT_INTERFACE=""
if ip link show "$VPN_INTERFACE" up > /dev/null 2>&1; then
    CURRENT_INTERFACE="$VPN_INTERFACE"
elif ip link show "$VPN_INTERFACE_WG" up > /dev/null 2>&1; then
    CURRENT_INTERFACE="$VPN_INTERFACE_WG"
fi

if [ -n "$CURRENT_INTERFACE" ]; then
    VPN_IP=$(ip -4 addr show "$CURRENT_INTERFACE" | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n 1)
    if [ -n "$VPN_IP" ]; then
      echo "{\"text\":\"${ICON_ON} ${TEXT_ON}\", \"tooltip\":\"Connected: ${VPN_IP}\", \"class\":\"${CLASS_ON}\"}"
    else
      echo "{\"text\":\"${ICON_ON} ${TEXT_ON}\", \"tooltip\":\"Connected (IP not found)\", \"class\":\"${CLASS_ON}\"}"
    fi
else
    echo "{\"text\":\"${ICON_OFF} ${TEXT_OFF}\", \"tooltip\":\"Disconnected\", \"class\":\"${CLASS_OFF}\"}"
fi
