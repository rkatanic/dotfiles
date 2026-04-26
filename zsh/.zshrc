# Path to your oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# LOAD OH MY ZSH (Using the full path to be 100% sure)
source $HOME/.oh-my-zsh/oh-my-zsh.sh

export NVM_DIR="$HOME/.nvm"

# This loads nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# This loads nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  

# User Aliases
alias dps='docker ps'
alias dcu='docker compose up -d'

# Run Fastfetch
fastfetch
