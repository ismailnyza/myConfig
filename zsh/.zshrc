export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
  git
  sudo
  docker
  docker-compose
  golang
  node
  npm
  yarn
  ubuntu
  command-not-found
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

autoload -U compinit && compinit

autoload -U bashcompinit && bashcompinit

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY
setopt AUTO_CD
setopt INTERACTIVE_COMMENTS
setopt EXTENDED_GLOB

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' rehash true

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

export EDITOR="nvim"
export VISUAL="nvim"
export GOPATH="$HOME/go"
export PATH="$HOME/.local/bin:$GOPATH/bin:$PATH"

alias vim='nvim'
alias ll='ls -lah'
alias gs='git status'
alias gc='git commit'
alias gp='git push'
alias k='kubectl'

if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
  alias fd='fdfind'
fi
