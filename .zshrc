# ==============================================================================
# 1. ENVIRONMENT VARIABLES & PATH
# ==============================================================================
typeset -U path PATH

export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/local/sbin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.embulk/bin:$PATH"

# Java
export JAVA_HOME=$(/usr/libexec/java_home -v 21)
export PATH="$JAVA_HOME/bin:$PATH"

# Maven
export MAVEN_HOME="/Library/apache-maven-3.9.7"
export PATH="$MAVEN_HOME/bin:$PATH"

# Node.js & NVM
export PATH="/opt/homebrew/opt/node@22/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# ==============================================================================
# 2. COMPLETION
# ==============================================================================
autoload -Uz compinit
compinit -C -d ~/.zcompdump

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'm:{a-zA-Z}={A-Za-z} l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{yellow}── %d ──%f'
zstyle ':completion:*:messages' format '%F{purple}%d%f'
zstyle ':completion:*:warnings' format '%F{red}No matches found%f'
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
setopt AUTO_MENU

# ==============================================================================
# 3. HISTORY & KEYBINDINGS
# ==============================================================================
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS

# History substring search
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey "$terminfo[kcuu1]" up-line-or-beginning-search 2>/dev/null
bindkey "$terminfo[kcud1]" down-line-or-beginning-search 2>/dev/null

# ==============================================================================
# 4. CLI TOOLS
# ==============================================================================

# Bat
if command -v bat >/dev/null 2>&1; then
  export BAT_THEME="TwoDark"
  alias cat="bat --paging=never"
  alias preview="bat"
fi

# FZF
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
  export FZF_CTRL_T_OPTS="
    --style full
    --walker-skip .git,node_modules,target,build,.idea,.gradle
    --preview 'bat -n --color=always {}'
  "
fi

# Zoxide
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
  alias cd="z"
fi

# Eza
if command -v eza >/dev/null 2>&1; then
  alias ls="eza --icons --git --group-directories-first"
  alias l="eza -la --icons --git --group-directories-first --no-filesize"
  alias ll="eza -la --icons --octal-permissions --group-directories-first --git"
  alias lt="eza --tree --level=2 --icons"
fi

# ==============================================================================
# 5. ALIASES & FUNCTIONS
# ==============================================================================
alias start='yarn start'
alias dev='yarn start:dev'

# Java version switchers
alias j17='export JAVA_HOME=$(/usr/libexec/java_home -v 17) && export PATH="$JAVA_HOME/bin:$PATH" && java -version'
alias j21='export JAVA_HOME=$(/usr/libexec/java_home -v 21) && export PATH="$JAVA_HOME/bin:$PATH" && java -version'

# Terminate processes by port
kill_port() {
  local port="${1:-8080}"
  local pids=$(lsof -ti:"$port")
  if [ -n "$pids" ]; then
    echo "$pids" | xargs kill -9
    echo "Port $port freed (PID: $pids)"
  else
    echo "No process running on port $port"
  fi
}

# ==============================================================================
# 6. PROMPT & PLUGINS
# ==============================================================================
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

