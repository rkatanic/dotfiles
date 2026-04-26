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

# Aliases

# Docker
alias dps='docker ps'
alias dcu='docker compose up -d'
alias dstats='docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"'
# Follow logs for a specific container
alias dlog='docker logs -f'

# Drizzle ORM
alias drizzle-generate='npx drizzle-kit generate'
alias drizzle-push='npx drizzle-kit push'
alias drizzle-studio='npx drizzle-kit studio'

# Run Fastfetch
fastfetch
