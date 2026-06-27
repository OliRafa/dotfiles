# .zshenv — sourced by ALL zsh invocations: interactive shells, scripts,
# `zsh -c`, subprocesses (nvim `:!`, jailed `zsh -c`, etc.).
# Keep this minimal: environment + PATH only. No output, no slow commands.

# Homebrew (PATH, MANPATH, HOMEBREW_*). Lives here, NOT in .zshrc, because
# .zshrc is sourced for interactive shells only — non-interactive shells need
# brew on PATH too (this is why scripts / nvim / jailed `zsh -c` couldn't find
# brew-installed tools before).
if [[ $(uname) == "Darwin" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# User-local binaries. $HOME (not a hardcoded path) so it works for any user —
# e.g. `dev` inside the devcontainer.
export PATH="$HOME/.local/bin:$PATH"

# De-duplicate PATH entries.
typeset -U path
