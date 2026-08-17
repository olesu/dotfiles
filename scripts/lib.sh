#!/usr/bin/env bash
# Shared helpers for dotfiles scripts.

# Calls the 1Password-backed gh wrapper directly, bypassing PATH ordering issues
# in environments where ~/.local/bin is not ahead of /opt/homebrew/bin.
_gh() {
  "$HOME/.local/bin/gh" "$@"
}

# Derives "<owner>/<repo>" from the origin remote of the git repo at $1,
# purely from local git config — no GitHub API call, so it still works when
# GitHub's API is degraded or unreachable (repo detection shouldn't depend
# on the network at all). Handles git@host:owner/repo.git, ssh://host/...,
# and https://host/... remote URL forms. Prints nothing and returns 1 if
# $1 isn't a git repo, has no origin remote, or the remote isn't a
# github.com URL (callers should fall back to `_gh repo view` for those
# exotic cases, e.g. GitHub Enterprise).
_repo_name_from_git() {
  local dir="$1" url
  url=$(git -C "$dir" remote get-url origin 2>/dev/null) || return 1
  [[ -n "$url" ]] || return 1
  if [[ "$url" =~ github\.com[:/]([^/]+/[^/]+)/?$ ]]; then
    local owner_repo="${BASH_REMATCH[1]}"
    owner_repo="${owner_repo%/}"
    owner_repo="${owner_repo%.git}"
    printf '%s\n' "$owner_repo"
    return 0
  fi
  return 1
}
