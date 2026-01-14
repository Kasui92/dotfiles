#!/bin/bash
# Install LazyGit

install() {
    cd /tmp
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit -D -t /usr/local/bin/
    rm lazygit.tar.gz lazygit
    cd -
}

if [ "${DOTFILES_INSTALL_FORCE:-0}" = "1" ]; then
    install
else
    if ! command -v lazygit &> /dev/null; then
        read -p "Do you want to install lazygit? [y/N]: " response
        if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
            install
        fi
    fi
fi
