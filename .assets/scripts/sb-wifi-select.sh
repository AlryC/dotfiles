#!/bin/bash

# Function to change cursor to waiting state
set_wait_cursor() {
    xsetroot -cursor_name watch &
    sleep 0.1  # Give X time to update cursor
}

# Function to restore default cursor
restore_cursor() {
    xsetroot -cursor_name left_ptr &
}

# Get a list of known networks
known_networks=$(wpa_cli list_networks | awk 'NR>2 {print $2}' | grep -v '^$')

# Append option to scan for new networks
menu_options=$(echo -e "$known_networks\nScan for new networks")

# Show rofi menu with known networks
ssid=$(echo -e "$menu_options" | rofi -dmenu -p "Select known Wi-Fi:" -l 10)

# Exit if no selection was made
[ -z "$ssid" ] && exit 1

# If the user selected "Scan for new networks", perform a scan
if [ "$ssid" == "Scan for new networks" ]; then
    set_wait_cursor  # Change cursor to waiting state

    # Trigger a Wi-Fi scan
    wpa_cli scan > /dev/null
    sleep 2  # Wait for scan to complete

    # Get only the SSID column from scan results, filtering out empty and duplicate entries
    networks=$(wpa_cli scan_results | awk 'NR>2 {print $5}' | sort -u | grep -v '^$')

    restore_cursor  # Restore default cursor

    # Show new networks in rofi
    ssid=$(echo -e "$networks" | rofi -dmenu -p "Select new Wi-Fi:" -l 10)

    # Exit if no selection was made
    [ -z "$ssid" ] && exit 1
fi

# Check if the network is already known
network_id=$(wpa_cli list_networks | awk -v ssid="$ssid" '$2 == ssid {print $1}')

if [ -z "$network_id" ]; then
    # If network isn't known, ask for a password
    password=$(rofi -dmenu -p "Enter password for $ssid:")

    # Exit if no password was entered
    [ -z "$password" ] && exit 1

    # Add the network and set the SSID
    network_id=$(wpa_cli add_network | awk '{print $1}')
    wpa_cli set_network "$network_id" ssid "\"$ssid\""
    wpa_cli set_network "$network_id" psk "\"$password\""
    wpa_cli enable_network "$network_id"
    wpa_cli save_config > /dev/null
else
    # If the network is known, just select it
    wpa_cli select_network "$network_id" > /dev/null
fi

echo "Connected to $ssid"
