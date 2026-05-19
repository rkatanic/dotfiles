#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

echo "--- Starting Development Stack Installation ---"

# --------------------------------------------------
# NVM + Node.js (LTS)
# --------------------------------------------------
NVM_VERSION="v0.40.3"

if [ ! -d "$HOME/.nvm" ]; then
    echo "--- Installing NVM ($NVM_VERSION) ---"

    curl -fsSL \
        "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" \
        | bash

    export NVM_DIR="$HOME/.nvm"

    if [ -s "$NVM_DIR/nvm.sh" ]; then
        . "$NVM_DIR/nvm.sh"
    else
        echo "ERROR: Failed to load NVM."
        exit 1
    fi

    echo "--- Installing Node.js LTS ---"
    nvm install --lts
    nvm use --lts
    nvm alias default 'lts/*'

    echo "--- Node.js setup complete ---"
else
    echo "--- NVM already installed ---"

    export NVM_DIR="$HOME/.nvm"

    if [ -s "$NVM_DIR/nvm.sh" ]; then
        . "$NVM_DIR/nvm.sh"
    fi
fi

# --------------------------------------------------
# SDKMAN! + Java
# --------------------------------------------------
echo "--- Checking SDKMAN! ---"

export SDKMAN_DIR="$HOME/.sdkman"

if [ ! -d "$SDKMAN_DIR" ]; then
    echo "--- Installing SDKMAN! ---"

    curl -fsSL "https://get.sdkman.io" | bash
fi

if [ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]; then
    # SDKMAN is incompatible with set -u
    set +u
    source "$SDKMAN_DIR/bin/sdkman-init.sh"
    set -u
else
    echo "ERROR: SDKMAN installation failed."
    exit 1
fi

if ! command -v java &>/dev/null; then
    echo "--- Installing Java 21 (Temurin LTS) ---"
    sdk install java 21-tem
else
    echo "--- Java already installed ---"
fi

# --------------------------------------------------
# Docker Engine + Compose
# --------------------------------------------------
if ! command -v docker &>/dev/null; then
    echo "--- Installing Docker Engine ---"

    DOCKER_REPO="/etc/apt/sources.list.d/docker.list"
    DOCKER_KEYRING="/etc/apt/keyrings/docker.gpg"

    sudo mkdir -p /etc/apt/keyrings

    if [ ! -f "$DOCKER_KEYRING" ]; then
        echo "--- Adding Docker GPG key ---"

        curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
            sudo gpg --dearmor \
            -o "$DOCKER_KEYRING"
    fi

    if [ ! -f "$DOCKER_REPO" ]; then
        echo "--- Adding Docker repository ---"

        echo \
"deb [arch=$(dpkg --print-architecture) signed-by=$DOCKER_KEYRING] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" |
        sudo tee "$DOCKER_REPO" >/dev/null
    else
        echo "--- Docker repository already exists ---"
    fi

    echo "--- Installing Docker packages ---"

    sudo apt update

    sudo apt install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin
else
    echo "--- Docker already installed ---"
fi

# --------------------------------------------------
# Docker permissions
# --------------------------------------------------
if command -v docker &>/dev/null; then
    if ! groups "$USER" | grep -qw docker; then
        echo "--- Adding user to docker group ---"

        sudo usermod -aG docker "$USER"

        echo
        echo "Docker permissions updated."
        echo "Please log out and back in."
    else
        echo "--- User already in docker group ---"
    fi
fi

echo
echo "===================================="
echo " Development setup complete"
echo "===================================="