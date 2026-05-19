#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

echo "--- Starting Development Stack Installation ---"

# --------------------------------------------------
# NVM + Node.js (LTS)
# --------------------------------------------------
if [ ! -d "$HOME/.nvm" ]; then
    echo "--- Installing NVM ---"

    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

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
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
fi

# --------------------------------------------------
# SDKMAN! + Java
# --------------------------------------------------
echo "--- Checking SDKMAN! ---"

if [ ! -d "$HOME/.sdkman" ]; then
    echo "--- Installing SDKMAN! ---"

    curl -s "https://get.sdkman.io" | bash

    export SDKMAN_DIR="$HOME/.sdkman"

    if [ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]; then
        source "$HOME/.sdkman/bin/sdkman-init.sh"
    else
        echo "ERROR: SDKMAN installation failed."
        exit 1
    fi

    echo "--- Installing Java 21 (Temurin LTS) ---"
    sdk install java 21-tem
else
    echo "--- SDKMAN already installed ---"

    export SDKMAN_DIR="$HOME/.sdkman"
    [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && \
        source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# --------------------------------------------------
# Docker Engine + Compose
# --------------------------------------------------
if ! command -v docker &> /dev/null; then
    echo "--- Installing Docker Engine ---"

    DOCKER_REPO="/etc/apt/sources.list.d/docker.list"

    if [ ! -f "$DOCKER_REPO" ]; then
        echo "--- Adding Docker repository ---"

        sudo mkdir -p /etc/apt/keyrings

        curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
            sudo gpg --dearmor \
            -o /etc/apt/keyrings/docker.gpg

        echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
        https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" |
        sudo tee "$DOCKER_REPO" > /dev/null
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

    echo "--- Configuring Docker permissions ---"

    if ! groups "$USER" | grep -qw docker; then
        sudo usermod -aG docker "$USER"

        echo
        echo "Docker group added to user."
        echo "Please log out and back in."
    else
        echo "--- User already in docker group ---"
    fi
else
    echo "--- Docker already installed ---"

    if ! groups "$USER" | grep -qw docker; then
        echo "--- Adding user to docker group ---"
        sudo usermod -aG docker "$USER"

        echo
        echo "Please log out and back in for Docker permissions."
    fi
fi

echo
echo "===================================="
echo " Development setup complete"
echo "===================================="