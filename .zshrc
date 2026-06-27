# Homebrew env (PATH, MANPATH, HOMEBREW_*) is initialized in ~/.zshenv so it
# applies to non-interactive shells too (scripts, nvim subprocesses, jailed
# `zsh -c`). Do not re-init it here — .zshrc is interactive-only.

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Cache brew prefix once (avoids spawning `brew --prefix` repeatedly below).
brew_prefix="$(brew --prefix 2>/dev/null)"

# Load omarchy-zsh configuration
if [[ -d /usr/share/omarchy-zsh/conf.d ]]; then
  for config in /usr/share/omarchy-zsh/conf.d/*.zsh; do
    [[ -f "$config" ]] && source "$config"
  done
fi

# Load omarchy-zsh functions and aliases
if [[ -d /usr/share/omarchy-zsh/functions ]]; then
  for func in /usr/share/omarchy-zsh/functions/*.zsh; do
    [[ -f "$func" ]] && source "$func"
  done
fi

# Add your own customizations below

typeset -U path cdpath fpath manpath

# History options should be set in .zshrc and after oh-my-zsh sourcing.
HISTSIZE="10000"
SAVEHIST="10000"

HISTFILE="$HOME/.zsh_history"

setopt HIST_FCNTL_LOCK

# Enabled history options
enabled_opts=(
  HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY
)
for opt in "${enabled_opts[@]}"; do
  setopt "$opt"
done
unset opt enabled_opts

# Disabled history options
disabled_opts=(
  APPEND_HISTORY EXTENDED_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_FIND_NO_DUPS
  HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS
)
for opt in "${disabled_opts[@]}"; do
  unsetopt "$opt"
done
unset opt disabled_opts

if [[ $options[zle] = on ]]; then
  source <(fzf --zsh)
fi

if type brew &>/dev/null; then
  FPATH=$brew_prefix/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

[[ -r $brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
  source $brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# We need to initialize the transient prompt theme before initializing Starship
[[ -r $brew_prefix/share/zsh-transient-prompt/transient-prompt.zsh-theme ]] && \
  source $brew_prefix/share/zsh-transient-prompt/transient-prompt.zsh-theme

# Initialize starship prompt
eval "$(starship init zsh)"

# After initializing Starship, we can define the env vars for transient prompt
TRANSIENT_PROMPT_PROMPT='$(starship prompt --terminal-width="$COLUMNS" --keymap="${KEYMAP:-}" --status="$STARSHIP_CMD_STATUS" --pipestatus="${STARSHIP_PIPE_STATUS[*]}" --cmd-duration="${STARSHIP_DURATION:-}" --jobs="$STARSHIP_JOBS_COUNT")'
TRANSIENT_PROMPT_RPROMPT='$(starship prompt --right --terminal-width="$COLUMNS" --keymap="${KEYMAP:-}" --status="$STARSHIP_CMD_STATUS" --pipestatus="${STARSHIP_PIPE_STATUS[*]}" --cmd-duration="${STARSHIP_DURATION:-}" --jobs="$STARSHIP_JOBS_COUNT")'
TRANSIENT_PROMPT_TRANSIENT_PROMPT='$(starship module character)'

# Initialize zoxide
eval "$(zoxide init zsh)"

# Load aliases
[[ -r ~/.zsh/aliases ]] && source ~/.zsh/aliases

# Loading functions in functions base folder ((N) => no error if dir is empty)
for f in ~/.zsh/functions/*(N); do source "$f"; done

# Custom functions
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Better cd with zoxide fallback
function cd {
  if [ -d "$1" ] || [ -z "$1" ]; then
    builtin cd "$@"
  else
    z "$@"
  fi
}

if test -n "$KITTY_INSTALLATION_DIR"; then
  export KITTY_SHELL_INTEGRATION="no-rc"
  autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
  kitty-integration
  unfunction kitty-integration
fi
