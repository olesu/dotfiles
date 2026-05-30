#!/opt/homebrew/bin/bash
#
# Checks pinned supply chain dependencies for upstream updates.
# Fetches upstream for each, then prints one structured line per dependency:
#
#   <name> <pinned-sha> up-to-date
#   <name> <pinned-sha> outdated <upstream-sha> <new-commit-count>
#
# Exit code 0 regardless — caller decides what to do with the output.

set -euo pipefail

GIT=/usr/bin/git
DOTFILES="$HOME/.dotfiles"
ANTIDOTE_CACHE="$HOME/Library/Caches/antidote"

# --- TPM ---

TPM_DIR="$HOME/.tmux/plugins/tpm"
TPM_PINNED=$(grep -o '[0-9a-f]\{40\}' "$DOTFILES/tmux/tmux.conf" | head -1)

if [[ -d "$TPM_DIR" ]]; then
    $GIT -C "$TPM_DIR" fetch -q origin 2>/dev/null
    TPM_UPSTREAM=$($GIT -C "$TPM_DIR" rev-parse origin/master)
    if [[ "$TPM_UPSTREAM" == "$TPM_PINNED" ]]; then
        echo "TPM $TPM_PINNED up-to-date"
    else
        COUNT=$($GIT -C "$TPM_DIR" rev-list --count "${TPM_PINNED}..origin/master")
        echo "TPM $TPM_PINNED outdated $TPM_UPSTREAM $COUNT"
    fi
else
    echo "TPM $TPM_PINNED skipped (not installed)"
fi

# --- lazy.nvim ---

LAZY_DIR="$HOME/.local/share/nvim/lazy/lazy.nvim"
LAZY_PINNED=$(grep 'pinned_lazy_sha' "$DOTFILES/nvim/lua/config/lazy.lua" | grep -o '"[0-9a-f]*"' | tr -d '"')

if [[ -d "$LAZY_DIR" ]]; then
    $GIT -C "$LAZY_DIR" fetch -q --tags origin 2>/dev/null
    LATEST_TAG=$($GIT -C "$LAZY_DIR" tag --sort=-version:refname | grep -v '^stable$' | head -1)
    LAZY_UPSTREAM=$($GIT -C "$LAZY_DIR" rev-parse "$LATEST_TAG")
    if [[ "$LAZY_UPSTREAM" == "$LAZY_PINNED" ]]; then
        echo "lazy.nvim $LAZY_PINNED up-to-date"
    else
        COUNT=$($GIT -C "$LAZY_DIR" rev-list --count "${LAZY_PINNED}..${LATEST_TAG}" 2>/dev/null || echo "?")
        echo "lazy.nvim $LAZY_PINNED outdated $LAZY_UPSTREAM $COUNT"
    fi
else
    echo "lazy.nvim $LAZY_PINNED skipped (not installed)"
fi

# --- Antidote zsh plugins ---

while IFS=' ' read -r repo locked_sha rest; do
    [[ "$repo" == \#* || -z "$repo" ]] && continue

    encoded="${repo/\//-SLASH-}"
    dir="$ANTIDOTE_CACHE/https-COLON--SLASH--SLASH-github.com-SLASH-${encoded}"

    if [[ ! -d "$dir" ]]; then
        echo "$repo $locked_sha skipped (not installed)"
        continue
    fi

    $GIT -C "$dir" fetch -q origin 2>/dev/null
    upstream=$($GIT -C "$dir" rev-parse origin/HEAD)

    if [[ "$upstream" == "$locked_sha" ]]; then
        echo "$repo $locked_sha up-to-date"
    else
        count=$($GIT -C "$dir" rev-list --count "${locked_sha}..origin/HEAD")
        echo "$repo $locked_sha outdated $upstream $count"
    fi
done < "$DOTFILES/zsh/zsh_plugins.lock"
