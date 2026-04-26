#!/bin/bash

# --- OS Detection ---
OS="$(uname)"
echo "--- Detected OS: $OS ---"

# --- Ensure Stow is installed ---
if ! command -v stow &> /dev/null; then
    echo "Stow is not installed."
    if [ "$OS" == "Darwin" ]; then
        echo "Installing Stow via Homebrew..."
        brew install stow
    elif [ "$OS" == "Linux" ]; then
        echo "Installing Stow via APT..."
        sudo apt update && sudo apt install -y stow
    else
        echo "Unsupported OS for auto-install."
        exit 1
    fi
fi

# --- Path Management ---
# This identifies the absolute path to your dotfiles root folder
DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

echo "--- Navigating to $DOTFILES_DIR ---"
cd "$DOTFILES_DIR"

# --- Cleanup to prevent Stow Conflicts ---
# Stow will fail if a real file exists where it wants to put a link
echo "--- Cleaning up existing local configs ---"
rm -f ~/.zshrc
rm -rf ~/.config/fastfetch

# --- Execute Stow ---
echo "--- Syncing Dotfiles ---"
# We loop through all top-level directories (zsh, fastfetch, etc.)
# and stow them one by one. This is the most reliable way to handle links.
for dir in */; do
    # Remove trailing slash for the package name
    package=${dir%/}
    
    # Skip the 'scripts' folder and '.git' folder
    if [ "$package" != "scripts" ] && [ "$package" != ".git" ]; then
        echo "Linking package: $package"
        stow -vR -t "$HOME" "$package"
    fi
done

echo "--- Linking Complete! ---"
