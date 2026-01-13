#!/bin/bash
# Install Fastfetch
default_response="N"
if ! command -v fastfetch &>/dev/null; then
    read -p "Do you want to install Fastfetch? [y/N]: " response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
      sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
      sudo apt update -y
      sudo apt install -y fastfetch
    fi
fi


