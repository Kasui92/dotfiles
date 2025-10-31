#!/bin/bash

set -o pipefail

# Bootstrap script for dotfiles installation
# This script clones the dotfiles repository and sets up the dotfiles command

# Use custom repo if specified, otherwise use default
DOTFILES_REPO="${DOTFILES_REPO:-Kasui92/dotfiles}"
DOTFILES_DIR="$HOME/.cfg"
LOCAL_BIN="$HOME/.local/bin"

# Colors for output
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
CYAN='\e[36m'
RESET='\e[0m'

# Check if already exists .cfg folders, if yes ask to remove
if [ -d "$DOTFILES_DIR" ]; then
  echo -e "${YELLOW}\nWarning: Dotfiles directory already exists at $DOTFILES_DIR${RESET}"
  read -p $'\e[36mDo you want to remove it and re-clone? (y/N): \e[0m' choice < /dev/tty
  choice=${choice:-N}
  case "$choice" in
    y|Y ) rm -rf "$DOTFILES_DIR" ;;
    n|N ) echo -e "${YELLOW}Skipping clone. Proceeding to setup dotfiles command.${RESET}" ;;
    * ) echo -e "${RED}Invalid choice. Aborting installation.${RESET}"; exit 1 ;;
  esac
fi

# Clone the dotfiles repository if not skipped
if [ ! -d "$DOTFILES_DIR" ]; then
  echo -e "${GREEN}\nCloning Dotfiles from https://github.com/$DOTFILES_REPO...${RESET}"
  if git clone "https://github.com/$DOTFILES_REPO.git" "$DOTFILES_DIR" >/dev/null 2>&1; then
    echo -e "${GREEN}✓ Dotfiles cloned successfully!${RESET}"
  else
    echo -e "${RED}✗ Failed to clone dotfiles repository.${RESET}"
    exit 1
  fi
fi

# Create ~/.local/bin directory if it doesn't exist
if [ ! -d "$LOCAL_BIN" ]; then
  echo -e "${CYAN}\nCreating $LOCAL_BIN directory...${RESET}"
  mkdir -p "$LOCAL_BIN"
fi

# Make the dotfiles script executable
chmod +x "$DOTFILES_DIR/dotfiles"

# Create symlink to dotfiles command
if [ -L "$LOCAL_BIN/dotfiles" ] || [ -e "$LOCAL_BIN/dotfiles" ]; then
  echo -e "${YELLOW}\nRemoving existing dotfiles command...${RESET}"
  rm -f "$LOCAL_BIN/dotfiles"
fi

echo -e "${CYAN}\nCreating symlink for dotfiles command...${RESET}"
ln -s "$DOTFILES_DIR/dotfiles" "$LOCAL_BIN/dotfiles"

# Check if ~/.local/bin is in PATH
if [[ ":$PATH:" != *":$LOCAL_BIN:"* ]]; then
  echo -e "${YELLOW}\nWarning: $LOCAL_BIN is not in your PATH.${RESET}"
  echo -e "${CYAN}Add the following line to your ~/.bashrc or ~/.zshrc:${RESET}"
  echo -e "  export PATH=\"\$HOME/.local/bin:\$PATH\""
  echo -e "${CYAN}\nOr run this command now:${RESET}"
  echo -e "  export PATH=\"\$HOME/.local/bin:\$PATH\""
fi

echo -e "${GREEN}\n✓ Bootstrap completed successfully!${RESET}"
echo -e "${CYAN}\nYou can now use the 'dotfiles' command:${RESET}"
echo -e "  ${GREEN}dotfiles help${RESET}     - Show available commands"
echo -e "  ${GREEN}dotfiles list${RESET}     - List available configurations"
echo -e "  ${GREEN}dotfiles install${RESET}  - Install a configuration\n"
