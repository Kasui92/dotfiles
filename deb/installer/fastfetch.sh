#!/bin/bash
# Install Fastfetch
if ! command -v fastfetch &>/dev/null; then
    read -p "Do you want to install Fastfetch? [y/N]: " response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        cd /tmp
        curl -sLo fastfetch.deb "https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch_linux_$(dpkg --print-architecture).deb"
        sudo dpkg -i fastfetch.deb
        rm fastfetch.deb
        cd -
    fi
fi


