#!/bin/bash
# Install lazydocker

install() {
    cd /tmp
    LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": "v\\K[^"]*')
    curl -sLo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz"
    tar -xf lazydocker.tar.gz lazydocker
    sudo install lazydocker /usr/local/bin
    rm lazydocker.tar.gz lazydocker
    cd -
}

if [ "${DOTFILES_INSTALL_FORCE:-0}" = "1" ]; then
    install
else
    if ! command -v lazydocker &> /dev/null; then
        read -p "Do you want to install lazydocker? [y/N]: " response
        if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
            install
        fi
    fi
fi
