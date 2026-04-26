#!/bin/bash

echo "--- Updating System & Adding Repos ---"
sudo apt update
# PPA for Fastfetch on Ubuntu
sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
sudo apt update

echo "--- Installing Core Packages ---"
sudo apt install -y git curl wget stow zsh fastfetch build-essential

# --- Oh My Zsh & Plugins ---
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "--- Installing Oh My Zsh ---"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo "--- Syncing Zsh Plugins ---"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && \
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# --- Call the Linker ---
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
"$SCRIPT_DIR/link.sh"

echo "--- Core Setup Complete ---"
