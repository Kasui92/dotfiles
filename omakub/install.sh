#!/bin/bash

# Add source command to .bashrc
if [ -f ~/.bashrc ]; then
    echo "source ~/.cfg/omakub/default/bash/rc" >> ~/.bashrc
    echo "export PATH=\"\$HOME/.cfg/omakub/bin:\$PATH\"" >> ~/.bashrc
fi

# Copy configuration
cp -r ~/.cfg/shared/config/* ~/.config/
cp -r ~/.cfg/omakub/config/* ~/.config/