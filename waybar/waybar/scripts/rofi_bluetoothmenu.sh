#!/bin/bash

MENU_CMD="rofi -dmenu -i -p Bluetooth -theme catppuccin-mocha -lines 10 -width 50"
SEPARATOR="-----"

show_menu() {
    # Power status
    power_status=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')
    if [ "$power_status" = "yes" ]; then
        power_option="Powered On (Toggle Off)" # nf-md-bluetooth
    else
        power_option="󰂲 Powered Off (Toggle On)" # nf-md-bluetooth_off
    fi

    # Scan status
    scan_status=$(bluetoothctl show | grep "Discovering:" | awk '{print $2}')
    if [ "$scan_status" = "yes" ]; then
        scan_option="󰂰 Scanning... (Toggle Off)" # nf-md-bluetooth_searching
    else
        scan_option="scanning Off (Toggle On)" # nf-md-bluetooth_search_off (use a different icon if available)
    fi
    
    options="$power_option\n$scan_option\n$SEPARATOR\nOpen Blueman Manager"

    # Paired and trusted devices
    devices=$(bluetoothctl devices Paired | awk '{print $2}' | while read -r mac; do
        name=$(bluetoothctl info "$mac" | grep "Name:" | cut -d' ' -f2-)
        connected=$(bluetoothctl info "$mac" | grep "Connected:" | awk '{print $2}')
        if [ "$connected" = "yes" ]; then
            echo -e "Connected to: $name ($mac)\t(Disconnect)"
        else
            echo -e "Disconnected: $name ($mac)\t(Connect)"
        fi
    done)

    if [ -n "$devices" ]; then
        options="$options\n$SEPARATOR\n$devices"
    fi
    
    # Discoverable devices (might be too many, optional)
    # discoverable_devices=$(bluetoothctl devices | grep -v Paired | awk '{print $2}' | while read -r mac; do
    // name=$(bluetoothctl info "$mac" | grep "Name:" | cut -d' ' -f2-)
    // echo -e "Nearby: $name ($mac)\t(Pair & Connect)"
    // done)
    // if [ -n "$discoverable_devices" ]; then
        // options="$options\n$SEPARATOR\n$discoverable_devices"
    // fi


    chosen_line=$(echo -e "$options" | $MENU_CMD)
    chosen_action=$(echo "$chosen_line" | awk -F'\t' '{print $2}' | tr -d '()')
    chosen_item=$(echo "$chosen_line" | awk -F'\t' '{print $1}')

    if [ -z "$chosen_line" ]; then
        exit 0
    fi

    if [[ "$chosen_line" == *"Powered On"* ]]; then
        bluetoothctl power off
    elif [[ "$chosen_line" == *"Powered Off"* ]]; then
        bluetoothctl power on
    elif [[ "$chosen_line" == *"Scanning..."* ]]; then
        bluetoothctl scan off
    elif [[ "$chosen_line" == *"Scanning Off"* ]]; then
        bluetoothctl scan on
    elif [[ "$chosen_line" == *"Blueman Manager"* ]]; then
        blueman-manager &
    elif [ -n "$chosen_action" ]; then
        mac=$(echo "$chosen_item" | grep -oP '\(\K[0-9A-F:]{17}') # Extract MAC
        if [ "$chosen_action" = "Connect" ]; then
            bluetoothctl connect "$mac"
        elif [ "$chosen_action" = "Disconnect" ]; then
            bluetoothctl disconnect "$mac"
        # Add pairing logic if needed for "Pair & Connect"
        fi
    fi
}

show_menu
