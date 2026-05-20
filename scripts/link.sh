#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# --------------------------------------------------
# OS Detection
# --------------------------------------------------
OS="$(uname)"
echo "--- Detected OS: $OS ---"

# --------------------------------------------------
# Ensure Stow is installed
# --------------------------------------------------
if ! command -v stow &>/dev/null; then
    echo "Stow is not installed."

    if [ "$OS" = "Darwin" ]; then
        echo "Installing Stow via Homebrew..."
        brew install stow

    elif [ "$OS" = "Linux" ]; then
        echo "Installing Stow via APT..."
        sudo apt update
        sudo apt install -y stow

    else
        echo "Unsupported OS for auto-install."
        exit 1
    fi
fi

# --------------------------------------------------
# Path Management
# --------------------------------------------------
DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

echo "--- Navigating to $DOTFILES_DIR ---"

if [ ! -d "$DOTFILES_DIR" ]; then
    echo "ERROR: DOTFILES_DIR does not exist:"
    echo "$DOTFILES_DIR"
    exit 1
fi

# --------------------------------------------------
# Detect Stow Packages
# --------------------------------------------------
ignored=(scripts .git .github)

packages=()

shopt -s nullglob

for dir in "$DOTFILES_DIR"/*/; do
    package=$(basename "$dir")

    [[ "$package" == .* ]] && continue

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
    echo "ERROR: No stow packages found in:"
    echo "$DOTFILES_DIR"
    exit 1
fi

echo "--- Detected stow packages ---"
printf " • %s\n" "${packages[@]}"

cd "$DOTFILES_DIR"

mkdir -p "$HOME/.config"

# --------------------------------------------------
# Validate + Stow
# --------------------------------------------------
echo "--- Validating and syncing dotfiles ---"

for package in "${packages[@]}"; do
    echo "Checking package: $package"

    stow_output=$(stow -nvR -t "$HOME" "$package" 2>&1 || true)

    if echo "$stow_output" | grep -Eqi \
        "conflict|cannot stow|existing target"; then

        echo "ERROR: Stow conflict detected for package:"
        echo "$package"
        echo
        echo "$stow_output"
        exit 1
    fi

    echo "Linking package: $package"

    stow -vR -t "$HOME" "$package"
done

echo "--- Linking Complete! ---"

echo "--- Validation ---"
echo "Configured shell: $(getent passwd "$USER" | cut -d: -f7 || echo 'unknown')"
echo "Zsh path: $(command -v zsh || echo 'zsh not found')"
echo "Zshrc symlink:"
ls -la "$HOME/.zshrc" || true