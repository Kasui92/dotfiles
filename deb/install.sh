#!/bin/bash

# Install apps and dependencies
INSTALLER_DIR="$HOME/.cfg/deb/install"

# Install base components
source "$INSTALLER_DIR/base.sh"
source "$INSTALLER_DIR/apps.sh"

# Add source command to .bashrc
if [ -f ~/.bashrc ]; then
    echo "source ~/.cfg/deb/default/bash/rc" >> ~/.bashrc
    echo "export PATH=\"\$HOME/.cfg/deb/bin:\$PATH\"" >> ~/.bashrc
fi

# Copy configuration
mkdir -p ~/.config/
cp -r ~/.cfg/deb/config/* ~/.config/