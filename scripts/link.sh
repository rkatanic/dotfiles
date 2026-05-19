#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

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
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "ERROR: DOTFILES_DIR does not exist: $DOTFILES_DIR"
    exit 1
fi

# --- Detect Stow packages dynamically ---
ignored=(scripts .git .github)
packages=()
shopt -s nullglob
for dir in "$DOTFILES_DIR"/*/; do
    package=$(basename "$dir")

    if [[ "$package" == .* ]]; then
        continue
    fi

    skip=false
    for ignore in "${ignored[@]}"; do
        if [ "$package" = "$ignore" ]; then
            skip=true
            break
        fi
    done

    if [ "$skip" = false ]; then
        packages+=("$package")
    fi
done
shopt -u nullglob

if [ ${#packages[@]} -eq 0 ]; then
    echo "ERROR: No stow packages found in $DOTFILES_DIR"
    echo "Please confirm your dotfiles repository contains package directories to link."
    exit 1
fi

echo "Detected stow packages: ${packages[*]}"
cd "$DOTFILES_DIR"

mkdir -p "$HOME/.config"

# --- Execute Stow ---
echo "--- Validating and syncing dotfiles ---"
for package in "${packages[@]}"; do
    echo "Checking package: $package"
    if ! stow -nvR -t "$HOME" "$package"; then
        echo "ERROR: Stow conflict detected for package: $package"
        echo "Resolve conflicting files manually before rerunning the bootstrap."
        exit 1
    fi

    echo "Linking package: $package"
    if ! stow -vR -t "$HOME" "$package"; then
        echo "ERROR: Failed to stow package: $package"
        exit 1
    fi
done

echo "--- Linking Complete! ---"

echo "--- Validation ---"
echo "Configured shell: $(getent passwd "$USER" | cut -d: -f7 || echo 'unknown')"
echo "Zsh path: $(command -v zsh || echo 'zsh not found')"
echo "Zshrc symlink:"
ls -la "$HOME/.zshrc" || true
