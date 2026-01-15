#!/bin/bash

# Install apps and dependencies
INSTALLER_DIR="$HOME/.cfg/deb/installer"

# Install base components
BASE_SCRIPT="$INSTALLER_DIR/base.sh"
if [ -f "$BASE_SCRIPT" ]; then
    source "$BASE_SCRIPT"
fi

# Install additional components, excluding base.sh
for script in "$INSTALLER_DIR"/*.sh; do
    [[ "$script" == *base.sh ]] && continue
    source "$script"
done

# Add source command to .bashrc
if [ -f ~/.bashrc ]; then
    echo "source ~/.cfg/deb/default/bash/rc" >> ~/.bashrc
    echo "export PATH=\"\$HOME/.cfg/deb/bin:\$PATH\"" >> ~/.bashrc
fi

# Copy configuration
mkdir -p ~/.config/
cp -r ~/.cfg/deb/config/* ~/.config/