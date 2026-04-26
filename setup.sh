#!/bin/bash

# Ensure all scripts in the scripts directory are executable
chmod +x scripts/*.sh

clear
echo "===================================================="
echo "          RADIVOJE'S DOTFILES WIZARD                "
echo "===================================================="
echo "1) [CORE]    - Install Apps & Link Configs"
echo "2) [FULL]    - Core + Docker + Node.js/NVM"
echo "3) [RE-LINK] - Only Refresh Symlinks (link.sh)"
echo "4) [EXIT]    - Close"
echo "----------------------------------------------------"

read -p "Enter choice [1-4]: " choice

case $choice in
    1)
        ./scripts/install_core.sh
        ;;
    2)
        ./scripts/install_core.sh
        ./scripts/install_dev.sh
        ;;
    3)
        ./scripts/link.sh
        ;;
    4)
        exit 0
        ;;
    *)
        echo "Invalid choice."
        exit 1
        ;;
esac

echo "----------------------------------------------------"
echo "  All done! Restart your terminal or 'source ~/.zshrc'"
echo "===================================================="
