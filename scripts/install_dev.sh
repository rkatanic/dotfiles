#!/bin/bash

# --- Development Stack Installation Script ---
# This script manages NVM, Node.js (LTS), and Docker Engine for Ubuntu.

echo "--- Starting Development Stack Installation ---"

# --- 1. NVM & Node.js (Dynamic Version Fetching) ---
# Check if NVM is already installed to avoid duplicates
if [ ! -d "$HOME/.nvm" ]; then
    echo "--- Fetching latest NVM version from GitHub API ---"
    
    # Retrieve the latest release tag name from GitHub repository
    NVM_LATEST_VERSION=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep "tag_name" | cut -d '"' -f 4)
    
    # Fallback to a known stable version if the API call fails or is rate-limited
    if [ -z "$NVM_LATEST_VERSION" ]; then
        echo "Warning: API fetch failed. Using fallback version v0.40.1"
        NVM_LATEST_VERSION="v0.40.1"
    fi

    echo "--- Installing NVM ($NVM_LATEST_VERSION) ---"
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_LATEST_VERSION}/install.sh" | bash
    
    # Immediately load NVM into this script's session to allow Node installation
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    echo "--- Installing Node.js LTS ---"
    nvm install --lts
else
    echo "--- NVM is already installed. Skipping Node setup. ---"
fi

# --- 2. Docker Engine & Docker Compose ---
# Check if Docker command exists on the system
if ! command -v docker &> /dev/null; then
    echo "--- Installing Docker Engine ---"
    
    # Update package index and install prerequisite packages
    sudo apt update
    sudo apt install -y ca-certificates gnupg lsb-release
    
    # Add Docker's official GPG key for security
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    
    # Set up the stable Docker repository
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Re-update the index and install Docker Engine, CLI, and Compose plugin
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    
    # Configure Docker group to allow running commands without sudo
    echo "--- Configuring Docker permissions ---"
    sudo usermod -aG docker $USER
    echo "SUCCESS: Docker installed. Note: Please log out and back in for group changes to apply."
else
    echo "--- Docker is already installed. Skipping. ---"
fi

echo "--- Development Stack Setup Complete ---"
