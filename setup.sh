#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# --------------------------------------------------
# Self-aware script location
# --------------------------------------------------
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$BASEDIR"

# --------------------------------------------------
# Ensure scripts are executable
# --------------------------------------------------
find ./scripts -name "*.sh" -exec chmod +x {} \;

# --------------------------------------------------
# Colors
# --------------------------------------------------
GREEN='\033[0;32m'
BOLD_GREEN='\033[1;32m'
NC='\033[0m'

clear

echo -e "${GREEN}====================================================${NC}"
echo -e "${BOLD_GREEN}           RADIVOJE'S DOTFILES WIZARD               ${NC}"
echo -e "${GREEN}====================================================${NC}"
echo "1) [CORE]    - Install Apps & Link Configs"
echo "2) [FULL]    - Core + Docker + Node.js/NVM"
echo "3) [RE-LINK] - Refresh Symlinks Only"
echo "4) [EXIT]"
echo -e "${GREEN}----------------------------------------------------${NC}"

read -rp "Enter choice [1-4]: " choice

case "$choice" in
    1)
        echo -e "${GREEN}Running Core Installation...${NC}"
        ./scripts/install_core.sh
        ;;

    2)
        echo -e "${GREEN}Running Full Installation (Core + Dev)...${NC}"
        ./scripts/install_core.sh
        ./scripts/install_dev.sh
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

echo
echo -e "${GREEN}====================================================${NC}"
echo -e "${BOLD_GREEN} Setup complete! ${NC}"
echo -e "${GREEN}====================================================${NC}"
echo "Open a new terminal or run:"
echo
echo "source ~/.zshrc"
echo
echo "If Docker permissions changed,"
echo "log out and back in."