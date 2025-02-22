#!/bin/bash

# Path to the fan mode file
AC_STATUS_FILE="/sys/class/power_supply/ACAD/online"
FAN_MODE_FILE="/sys/devices/platform/asus-nb-wmi/fan_boost_mode"

# Get the current power source
update_fan_mode(){
	if [[ $(cat "$AC_STATUS_FILE") -eq 1 ]]; then
    		# On AC power
    		echo 1 > "$FAN_MODE_FILE"  # Set to Performance mode
	else
    		# On battery
    		echo 2 > "$FAN_MODE_FILE"  # Set to Silent mode
fi
}

# Initial state
last_ac_status=$(cat "$AC_STATUS_FILE")
update_fan_mode # First Update

while true; do
    current_ac_status=$(cat "$AC_STATUS_FILE")
    
    # Check if the AC status has changed
    if [[ "$current_ac_status" -ne "$last_ac_status" ]]; then
        update_fan_mode  # Update fan mode if the status has changed
        last_ac_status="$current_ac_status"  # Update the last known status
    fi
    
    sleep 5  # Wait for 5 seconds before checking again
done
