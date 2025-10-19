#!/bin/bash

# Script to automatically manage monitor configuration on Hyprland
# Priority: external monitor when connected, laptop only when it's the only one

# ============ CONFIGURATION ============
# Read configuration from monitors.conf
CONFIG_FILE="$HOME/.config/hypr/monitors.conf"

# Extract values from monitors.conf
if [ -f "$CONFIG_FILE" ]; then
    LAPTOP_MONITOR=$(grep "^env = LAPTOP_MONITOR" "$CONFIG_FILE" | cut -d',' -f2 | tr -d ' ')
    LAPTOP_POSITION=$(grep "^env = LAPTOP_POSITION" "$CONFIG_FILE" | cut -d',' -f2 | tr -d ' ')
fi

# Fallback to defaults if not found
LAPTOP_MONITOR="${LAPTOP_MONITOR:-eDP-1}"
LAPTOP_POSITION="${LAPTOP_POSITION:-right}"
# =======================================

# Get list of all active monitors
ALL_MONITORS=$(hyprctl monitors -j | jq -r '.[].name')
EXTERNAL_MONITORS=$(echo "$ALL_MONITORS" | grep -v "$LAPTOP_MONITOR")

# Count external monitors
EXTERNAL_COUNT=$(echo "$EXTERNAL_MONITORS" | grep -v '^$' | wc -l)

# Check if laptop screen exists
LAPTOP_EXISTS=$(echo "$ALL_MONITORS" | grep -c "$LAPTOP_MONITOR")

# Determine primary monitor
if [ "$EXTERNAL_COUNT" -gt 0 ]; then
    PRIMARY_MONITOR=$(echo "$EXTERNAL_MONITORS" | head -n1)
    SECONDARY_MONITOR="$LAPTOP_MONITOR"
    notify-send "Monitor Setup" "External monitor detected: $PRIMARY_MONITOR set as primary" -t 3000
else
    PRIMARY_MONITOR="$LAPTOP_MONITOR"
    SECONDARY_MONITOR=""
    notify-send "Monitor Setup" "Laptop screen only: set as primary" -t 3000
fi

# Get number of workspaces configured in Hyprland
# Check for workspace configuration in hyprland.conf
HYPRLAND_CONF="$HOME/.config/hypr/hyprland.conf"
NUM_WORKSPACES=10  # Default fallback

if [ -f "$HYPRLAND_CONF" ]; then
    # Try to find workspace bindings to determine how many workspaces are configured
    MAX_WORKSPACE=$(grep -oP 'workspace\s*=?\s*\K\d+' "$HYPRLAND_CONF" 2>/dev/null | sort -n | tail -1)
    if [ -n "$MAX_WORKSPACE" ] && [ "$MAX_WORKSPACE" -gt 0 ]; then
        NUM_WORKSPACES="$MAX_WORKSPACE"
    fi
fi

# Configure primary monitor at position 0,0
hyprctl keyword monitor "$PRIMARY_MONITOR,preferred,0x0,1" > /dev/null 2>&1

# Bind workspaces 1-NUM_WORKSPACES to primary monitor only
for i in $(seq 1 "$NUM_WORKSPACES"); do
    hyprctl keyword workspace "$i,monitor:$PRIMARY_MONITOR,default:true" > /dev/null 2>&1
done

# Move all existing workspaces to primary monitor
EXISTING_WORKSPACES=$(hyprctl workspaces -j | jq -r '.[].id')
for workspace in $EXISTING_WORKSPACES; do
    hyprctl dispatch moveworkspacetomonitor "$workspace $PRIMARY_MONITOR" > /dev/null 2>&1
done

# Configure secondary monitor (laptop when external is connected)
if [ -n "$SECONDARY_MONITOR" ] && [ "$LAPTOP_EXISTS" -gt 0 ]; then
    case "$LAPTOP_POSITION" in
        "right")
            hyprctl keyword monitor "$SECONDARY_MONITOR,preferred,1920x0,1" > /dev/null 2>&1
            ;;
        "left")
            hyprctl keyword monitor "$PRIMARY_MONITOR,preferred,1920x0,1" > /dev/null 2>&1
            hyprctl keyword monitor "$SECONDARY_MONITOR,preferred,0x0,1" > /dev/null 2>&1
            ;;
        "above")
            hyprctl keyword monitor "$SECONDARY_MONITOR,preferred,0x-1080,1" > /dev/null 2>&1
            ;;
        "below")
            hyprctl keyword monitor "$SECONDARY_MONITOR,preferred,0x1080,1" > /dev/null 2>&1
            ;;
        "disable")
            hyprctl keyword monitor "$SECONDARY_MONITOR,disable" > /dev/null 2>&1
            ;;
        *)
            hyprctl keyword monitor "$SECONDARY_MONITOR,preferred,1920x0,1" > /dev/null 2>&1
            ;;
    esac

    # Create a fixed workspace for secondary monitor (NUM_WORKSPACES + 1)
    SECONDARY_WORKSPACE=$((NUM_WORKSPACES + 1))
    hyprctl keyword workspace "$SECONDARY_WORKSPACE,monitor:$SECONDARY_MONITOR,default:true" > /dev/null 2>&1
    hyprctl dispatch workspace "$SECONDARY_WORKSPACE" > /dev/null 2>&1
    hyprctl dispatch moveworkspacetomonitor "$SECONDARY_WORKSPACE $SECONDARY_MONITOR" > /dev/null 2>&1
fi

# Configure additional external monitors if present
if [ "$EXTERNAL_COUNT" -gt 1 ]; then
    OFFSET=1920
    WORKSPACE_NUM=$((NUM_WORKSPACES + 2))  # Start from NUM_WORKSPACES + 2
    for monitor in $(echo "$EXTERNAL_MONITORS" | tail -n +2); do
        if [ -n "$monitor" ]; then
            OFFSET=$((OFFSET + 1920))
            hyprctl keyword monitor "$monitor,preferred,${OFFSET}x0,1" > /dev/null 2>&1

            # Create fixed workspace for this monitor
            hyprctl keyword workspace "$WORKSPACE_NUM,monitor:$monitor,default:true" > /dev/null 2>&1
            hyprctl dispatch workspace "$WORKSPACE_NUM" > /dev/null 2>&1
            hyprctl dispatch moveworkspacetomonitor "$WORKSPACE_NUM $monitor" > /dev/null 2>&1

            WORKSPACE_NUM=$((WORKSPACE_NUM + 1))
        fi
    done
fi

# Switch to workspace 1 on primary monitor
hyprctl dispatch workspace 1 > /dev/null 2>&1