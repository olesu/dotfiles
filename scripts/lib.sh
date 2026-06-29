#!/usr/bin/env bash
# Shared helpers for dotfiles scripts.

# Calls the 1Password-backed gh wrapper directly, bypassing PATH ordering issues
# in environments where ~/.local/bin is not ahead of /opt/homebrew/bin.
_gh() {
  "$HOME/.local/bin/gh" "$@"
}
