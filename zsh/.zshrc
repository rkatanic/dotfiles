# Path to your oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# LOAD OH MY ZSH (Using the full path to be 100% sure)
source $HOME/.oh-my-zsh/oh-my-zsh.sh

# User Aliases
alias dps='docker ps'
alias dcu='docker compose up -d'

# Run Fastfetch
fastfetch
