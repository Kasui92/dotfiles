#!/bin/bash

# Update base system packages
sudo apt update -y
sudo apt upgrade -y

pkgs=(
    apache2-utils
    autoconf
    bat
    bison
    btop
    build-essential
    curl
    eza
    fd-find
    ffmpeg
    fzf
    git
    pkg-config
    plocate
    ripgrep
    tldr
    unzip
    wget
    zoxide
)

sudo apt install -y "${pkgs[@]}"
