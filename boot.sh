#!/bin/bash

set -o pipefail

# Use custom repo if specified, otherwise use default
DOTFILES_REPO="${DOTFILES_REPO:-Kasui92/dotfiles}"

# Check if already exists .cfg folders, if yes ask to remove
if [ -d ~/.cfg ]; then
  read -p "Dotfiles directory already exists. Do you want to remove it? (y/n) " choice
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