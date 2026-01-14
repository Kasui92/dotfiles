#!/bin/bash

# Add source command to .bashrc
if [ -f ~/.bashrc ]; then
    echo "source ~/.cfg/omarchy/default/bash/rc" >> ~/.bashrc
    echo "export PATH=\"\$HOME/.cfg/omarchy/bin:\$PATH\"" >> ~/.bashrc
fi

# Copy configuration
cp -r ~/.cfg/shared/config/* ~/.config/
cp -r ~/.cfg/omarchy/config/* ~/.config/