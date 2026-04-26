#!/bin/bash

# 1. Make the script "self-aware" of its location
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$BASEDIR"

# Green color scheme
GREEN='\033[0;32m'
BOLD_GREEN='\033[1;32m'
NC='\033[0m' # No Color

clear
echo -e "${GREEN}====================================================${NC}"
echo -e "${BOLD_GREEN}           RADIVOJE'S DOTFILES WIZARD               ${NC}"
echo -e "${GREEN}====================================================${NC}"
echo "1) [CORE]    - Install Apps & Link Configs"
echo "2) [FULL]    - Core + Docker + Node.js/NVM"
echo "3) [RE-LINK] - Only Refresh Symlinks (link.sh)"
echo "4) [EXIT]    - Close"
echo -e "${GREEN}----------------------------------------------------${NC}"

read -p "Enter choice [1-4]: " choice

# Ensure scripts are executable before running
chmod +x ./scripts/*.sh

case $choice in
    1)
        echo -e "${GREEN}Running Core Installation...${NC}"
        ./scripts/install_core.sh
        ./scripts/link.sh
        ;;
    2)
        echo -e "${GREEN}Running Full Installation (Core + Dev)...${NC}"
        ./scripts/install_core.sh
        ./scripts/install_dev.sh
        ./scripts/link.sh
        ;;
    3)
        echo -e "${GREEN}Refreshing Symlinks...${NC}"
        ./scripts/link.sh
        ;;
    4)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice."
        exit 1
        ;;
esac

echo -e "${GREEN}----------------------------------------------------${NC}"
echo -e "${BOLD_GREEN}  All done! Restart your terminal or 'source ~/.zshrc'${NC}"
echo -e "${GREEN}====================================================${NC}"
