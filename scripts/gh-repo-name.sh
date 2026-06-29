#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=scripts/lib.sh
source "$(dirname "$0")/lib.sh"

# Prints the GitHub repo name (owner/repo) for the current directory.
# Exits non-zero with an error message if not in a GitHub repo.
name=$(_gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null) || {
  echo "Not a GitHub repository" >&2
  exit 1
}

echo "$name"
