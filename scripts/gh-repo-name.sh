#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=scripts/lib.sh
source "$(dirname "$0")/lib.sh"

# Prints the GitHub repo(s) found at or under the current directory, as
# "<path>\t<owner/repo>" lines (path is "." for the cwd-is-a-repo case).
#
# If cwd itself isn't a GitHub repo, recursively scans subdirectories for
# git repos with a GitHub remote — this covers multi-repo workspace roots
# (e.g. a parent directory containing several project checkouts) where cwd
# has no .git of its own but its children do.
#
# Exit codes:
#   0 - exactly one repo found. One line on stdout.
#   1 - no GitHub repo found at cwd or in any subdirectory.
#   2 - multiple GitHub repos found in subdirectories; caller must
#       disambiguate. One line per candidate on stdout.

if git rev-parse --is-inside-work-tree &>/dev/null; then
  name=$(_repo_name_from_git .) || name=$(_gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null) || name=""
  if [[ -n "$name" ]]; then
    printf '.\t%s\n' "$name"
    exit 0
  fi
fi

# cwd isn't a repo — scan subdirectories, pruning common vendor/build/scratch
# noise so the walk stays fast and doesn't surface nested vendored repos or
# Claude Code worktree checkouts as candidates.
noise=(node_modules .build DerivedData Pods .venv venv vendor dist build Carthage .swiftpm .terraform worktrees)

prune_expr=(-name "${noise[0]}")
for dir in "${noise[@]:1}"; do
  prune_expr+=(-o -name "$dir")
done

mapfile -t git_dirs < <(
  find . -mindepth 1 \( "${prune_expr[@]}" \) -prune -o -type d -name .git -print -prune 2>/dev/null
)

candidates=()
for git_dir in "${git_dirs[@]}"; do
  repo_path=$(dirname "$git_dir")
  repo_name=$(_repo_name_from_git "$repo_path") \
    || repo_name=$(cd "$repo_path" && _gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null) \
    || continue
  candidates+=("$repo_path"$'\t'"$repo_name")
done

if [[ ${#candidates[@]} -eq 0 ]]; then
  echo "Not a GitHub repository (checked cwd and subdirectories)" >&2
  exit 1
elif [[ ${#candidates[@]} -eq 1 ]]; then
  echo "${candidates[0]}"
  exit 0
else
  printf '%s\n' "${candidates[@]}"
  exit 2
fi
