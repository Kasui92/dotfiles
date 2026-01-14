#!/bin/bash
# Install Fastfetch

install() {
    cd /tmp
    curl -sLo fastfetch.deb "https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-$(dpkg --print-architecture).deb"
    sudo dpkg -i fastfetch.deb
    rm fastfetch.deb
    cd -
}

if [ "${DOTFILES_INSTALL_FORCE:-0}" = "1" ]; then
    install
else
    if ! command -v fastfetch &> /dev/null; then
        read -p "Do you want to install fastfetch? [y/N]: " response
        if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
            install
        fi
    fi
fi


