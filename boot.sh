#!/bin/bash

set -o pipefail

# Use custom repo if specified, otherwise use default
DOTFILES_REPO="${DOTFILES_REPO:-Kasui92/dotfiles}"

# Check if already exists .cfg folders, if yes ask to remove
if [ -d ~/.cfg ]; then
  echo -e "\e[33m\nWarning: Dotfiles directory already exists.\e[0m"
  read -p $'\e[36mDo you want to remove it? (y/n): \e[0m' choice
  case "$choice" in
    y|Y ) rm -rf ~/.cfg ;;
    n|N ) echo "Aborting installation."; exit 1 ;;
    * ) echo "Invalid choice. Aborting installation."; exit 1 ;;
  esac
fi

# Clone the dotfiles repository
echo -e "\e[32m\nCloning Dotfiles...\e[0m"
git clone https://github.com/$DOTFILES_REPO.git ~/.cfg >/dev/null

echo -e "\e[32m\nDotfiles cloned successfully!\e[0m"

# Obtain list of folders in ~/.cfg, those are available configs to install
DOTFILES_DIR=~/.cfg
CONFIGS=$(find "$DOTFILES_DIR" -mindepth 1 -maxdepth 1 -type d)

# List the configs and ask user to select which ones to install
echo -e "\e[32m\nAvailable Configs:\e[0m"
select CONFIG in $CONFIGS; do
  case "$CONFIG" in
    "" ) echo "Invalid selection. Please try again." ;;
    * ) echo "You selected $CONFIG"; break ;;
  esac
done

if [ -n "$CONFIG" ]; then
  echo -e "\e[32m\nInstalling $CONFIG...\e[0m"
  source "$DOTFILES_DIR/$CONFIG/install.sh"
  echo -e "\e[32m\nInstallation of $CONFIG completed!\e[0m"
else
  echo -e "\e[31m\nNo valid config selected. Aborting installation.\e[0m"
  exit 1
fi
