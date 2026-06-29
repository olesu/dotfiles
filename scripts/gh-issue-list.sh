#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=scripts/lib.sh
source "$(dirname "$0")/lib.sh"

# Fetches open GitHub issues as JSON.
# Usage: gh-issue-list.sh [--limit N]
limit=100
if [[ "${1:-}" == "--limit" ]]; then
  limit="${2:?--limit requires a value}"
fi

_gh issue list --state open --limit "$limit" \
  --json number,title,labels,milestone,createdAt,updatedAt,comments,assignees
