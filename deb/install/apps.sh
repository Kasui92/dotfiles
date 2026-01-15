#!/bin/bash

# Install apps and dependencies
APPS_DIR="$HOME/.cfg/deb/applications"

# Install additional components
for script in "$APPS_DIR"/*.sh; do
    source "$script"
done