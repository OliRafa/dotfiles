# If not running interactively, don't do anything
[[ $- != *i* ]] && return

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
# oh-my-zsh extra settings for plugins
export ZSH="$HOME/.oh-my-zsh"
plugins=(
  colored-man-pages
  command-not-found
  docker
  extract
  git
  pip
  python
  sudo
  zsh-autosuggestions
)

ZSH_THEME="robbyrussell"
source $ZSH/oh-my-zsh.sh

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
  source <(/usr/bin/fzf --zsh)
fi

# Initialize starship prompt
eval "$(starship init zsh)"

# Initialize zoxide
eval "$(zoxide init zsh)"

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

if [[ $TERM != "dumb" ]]; then
  eval "$(/usr/bin/starship init zsh)"
fi

if test -n "$KITTY_INSTALLATION_DIR"; then
  export KITTY_SHELL_INTEGRATION="no-rc"
  autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
  kitty-integration
  unfunction kitty-integration
fi

alias -- ..='cd ..'
alias -- ...='cd ../..'
alias -- ....='cd ../../..'
alias -- c=clear
alias -- cat='bat --style=auto'
alias -- cd=z
alias -- df='df -h'
alias -- find=fd
alias -- g=git
alias -- gcam='git commit -am'
alias -- gcm='git commit -m'
alias -- gco='git checkout'
alias -- grep=rg
alias -- gst='git status'
alias -- la='eza -la --icons'
alias -- ll='eza -la --icons'
alias -- ls='eza --icons'
alias -- lt='eza --tree --icons'
alias -- ssh='kitten ssh'

