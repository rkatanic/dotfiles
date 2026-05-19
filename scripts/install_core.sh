#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

echo "--- Updating System & Adding Repos ---"

packages=(
    git
    curl
    wget
    stow
    zsh
    fastfetch
    build-essential
    zip
    unzip
)

missing_packages=()
for pkg in "${packages[@]}"; do
    if ! dpkg -s "$pkg" &> /dev/null; then
        missing_packages+=("$pkg")
    fi
done

ppa_name="zhangsongcui3371/fastfetch"
ppa_exists=false
if grep -rq "$ppa_name" /etc/apt/sources.list.d/ /etc/apt/sources.list 2>/dev/null; then
    ppa_exists=true
fi

if [ "$ppa_exists" = false ]; then
    echo "--- Adding Fastfetch PPA ---"
    sudo add-apt-repository -y ppa:$ppa_name
fi

if [ ${#missing_packages[@]} -gt 0 ] || [ "$ppa_exists" = false ]; then
    echo "--- Updating package index ---"
    sudo apt update
fi

if [ ${#missing_packages[@]} -gt 0 ]; then
    echo "--- Installing missing packages ---"
    sudo apt install -y "${missing_packages[@]}"
else
    echo "--- All core packages already installed ---"
fi

# --- Oh My Zsh & Plugins ---
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "--- Installing Oh My Zsh ---"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo "--- Syncing Zsh Plugins ---"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && \
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# --- Set Zsh as default shell if needed ---
ZSH_PATH=$(command -v zsh || true)
CURRENT_SHELL=$(getent passwd "$USER" | cut -d: -f7 || true)

if [ -n "$ZSH_PATH" ] && [ "$CURRENT_SHELL" != "$ZSH_PATH" ]; then
    echo "--- Setting Zsh as default shell ---"
    chsh -s "$ZSH_PATH"
    echo "Zsh set as default shell. Please log out and back in."
elif [ -z "$ZSH_PATH" ]; then
    echo "WARNING: zsh is not installed or not found in PATH. Skipping shell switch."
else
    echo "Zsh is already configured as the login shell: $CURRENT_SHELL"
fi

# --- Call the Linker ---
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
"$SCRIPT_DIR/link.sh"

echo "--- Validation ---"
echo "Configured shell: $(getent passwd "$USER" | cut -d: -f7 || echo 'unknown')"
echo "Zsh path: $(command -v zsh || echo 'zsh not found')"
echo "Zshrc symlink:"
ls -la "$HOME/.zshrc" || true

echo "--- Core Setup Complete ---"
