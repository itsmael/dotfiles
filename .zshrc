# Minimal zshrc for DBRE with Starship prompt indicator for kubectl usage
# - Shows kubernetes icon only if you ran kubectl recently (default: last 300s)
# - Uses Starship if installed (fast, cross-shell prompt)
# - Provides a lightweight 'k' wrapper for kubectl that records last use

export PATH="$HOME/bin:$HOME/.local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export EDITOR="nvim"
export LANG="en_US.UTF-8"

# HISTORY
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Basic aliases
alias ll='ls -lh'
alias la='ls -lah'
alias ..='cd ..'
alias ...='cd ../..'
alias gst='git status'
alias ga='git add .'
alias gp='git push'
alias d='docker'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'

# -------- kubectl wrapper "k"
# This wrapper executes kubectl and updates ~/.last_kubectl mtime.
# It preserves arguments and exit code.
k() {
  if ! command -v kubectl >/dev/null 2>&1; then
    echo "kubectl not found" >&2
    return 127
  fi

  # Run kubectl with all args
  kubectl "$@"
  local rc=$?

  # Update timestamp file to indicate kubectl was used
  # Use touch to update mtime; if touch exists it's fine
  # We ensure the file exists and has current mtime
  touch ~/.last_kubectl 2>/dev/null || : 

  return $rc
}
# Keep a compatibility alias if you prefer single-letter
alias kc='k'

# -------- Starship integration (if installed)
# Starship is the recommended lightweight prompt. If present, use it.
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
else
  # Fallback simple prompt if starship not installed
  PROMPT='%n@%m:%~$ '
fi

# -------- Optional: source completions if available (safe)
# kubectl completion (only if kubectl exists)
if command -v kubectl >/dev/null 2>&1; then
  # For zsh, allow kubectl completion; this is safe and won't print errors if not supported
  source <(kubectl completion zsh 2>/dev/null) 2>/dev/null || true
fi

# aws completion (if aws_completer installed)
if command -v aws_completer >/dev/null 2>&1; then
  autoload -U +X bashcompinit && bashcompinit
  complete -C aws_completer aws 2>/dev/null || true
fi

# quick helpers
alias sz='source ~/.zshrc'
alias ez='nvim ~/.zshrc'

#lab repo 
alias lab='cd ~/Documents/repos/lab/'

#second brain
alias sb='cd ~/Documents/repos/zettelkasten/'
