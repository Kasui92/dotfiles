#!/bin/bash

#!/bin/bash

# Copy all configurations from .cfg/config to ~/.config, preserving the folder structure
CONFIG_SRC="$(dirname "$0")/../config"
CONFIG_DEST="$HOME/.config"

echo "Copying configurations from $CONFIG_SRC to $CONFIG_DEST..."
cp -r "$CONFIG_SRC"/* "$CONFIG_DEST"/
echo "Configurations applied."

