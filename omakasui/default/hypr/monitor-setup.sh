#!/bin/bash

# Script to automatically manage monitor configuration on Hyprland
# Priority: external monitor when connected, laptop only when it's the only one

# ============ CONFIGURATION ============
LAPTOP_MONITOR=$(hyprctl get env LAPTOP_MONITOR)  # Change if your laptop uses a different name
LAPTOP_POSITION=$(hyprctl get env LAPTOP_POSITION) # Get current laptop position
# =======================================

# Get monitor status

# Get list of all active monitors
ALL_MONITORS=$(hyprctl monitors -j | jq -r '.[].name')
EXTERNAL_MONITORS=$(echo "$ALL_MONITORS" | grep -v "$LAPTOP_MONITOR")

# Count external monitors
EXTERNAL_COUNT=$(echo "$EXTERNAL_MONITORS" | grep -v '^$' | wc -l)

# Check if laptop screen exists and is on
LAPTOP_EXISTS=$(echo "$ALL_MONITORS" | grep -c "$LAPTOP_MONITOR")

if [ "$EXTERNAL_COUNT" -gt 0 ]; then
    # Get first external monitor (primary)
    FIRST_EXTERNAL=$(echo "$EXTERNAL_MONITORS" | head -n1)
    notify-send "Monitor Setup" "External monitor detected: $FIRST_EXTERNAL set as primary" -t 3000

    # Configure first external monitor as primary at position 0,0
    hyprctl keyword monitor "$FIRST_EXTERNAL,preferred,0x0,1" > /dev/null 2>&1

    # Move existing workspaces to the external monitor
    EXISTING_WORKSPACES=$(hyprctl workspaces -j | jq -r '.[].id')
    for workspace in $EXISTING_WORKSPACES; do
        hyprctl dispatch moveworkspacetomonitor "$workspace $FIRST_EXTERNAL" > /dev/null 2>&1
    done

    # Position laptop screen based on LAPTOP_POSITION setting
    if [ "$LAPTOP_EXISTS" -gt 0 ]; then
        case "$LAPTOP_POSITION" in
            "right")
                hyprctl keyword monitor "$LAPTOP_MONITOR,preferred,1920x0,1" > /dev/null 2>&1
                ;;
            "left")
                hyprctl keyword monitor "$FIRST_EXTERNAL,preferred,1920x0,1" > /dev/null 2>&1
                hyprctl keyword monitor "$LAPTOP_MONITOR,preferred,0x0,1" > /dev/null 2>&1
                ;;
            "above")
                hyprctl keyword monitor "$LAPTOP_MONITOR,preferred,0x-1080,1" > /dev/null 2>&1
                ;;
            "below")
                hyprctl keyword monitor "$LAPTOP_MONITOR,preferred,0x1080,1" > /dev/null 2>&1
                ;;
            "disable")
                hyprctl keyword monitor "$LAPTOP_MONITOR,disable" > /dev/null 2>&1
                ;;
            *)
                hyprctl keyword monitor "$LAPTOP_MONITOR,preferred,1920x0,1" > /dev/null 2>&1
                ;;
        esac
    fi

    # Configure additional external monitors if present
    OFFSET=1920
    for monitor in $(echo "$EXTERNAL_MONITORS" | tail -n +2); do
        if [ -n "$monitor" ]; then
            OFFSET=$((OFFSET + 1920))
            hyprctl keyword monitor "$monitor,preferred,${OFFSET}x0,1" > /dev/null 2>&1
        fi
    done

elif [ "$LAPTOP_EXISTS" -gt 0 ]; then
    notify-send "Monitor Setup" "Laptop screen only: set as primary" -t 3000

    # Configure laptop as the only monitor at position 0,0
    hyprctl keyword monitor "$LAPTOP_MONITOR,preferred,0x0,1" > /dev/null 2>&1

    # Move existing workspaces to laptop
    EXISTING_WORKSPACES=$(hyprctl workspaces -j | jq -r '.[].id')
    for workspace in $EXISTING_WORKSPACES; do
        hyprctl dispatch moveworkspacetomonitor "$workspace $LAPTOP_MONITOR" > /dev/null 2>&1
    done

else
    notify-send "Monitor Setup" "No monitors detected - using fallback" -u critical -t 3000
    hyprctl keyword monitor ",preferred,auto,1" > /dev/null 2>&1
fi