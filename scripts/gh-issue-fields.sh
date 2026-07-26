#!/usr/bin/env bash
set -euo pipefail

# Extracts title, state, labels, and body from a GitHub issue with jq — the
# replacement for ad-hoc inline JSON parsing when a skill needs one field of
# an issue programmatically. Builds on gh-issue-view.sh, which already goes
# through the 1Password-backed _gh wrapper, so this script doesn't need
# lib.sh itself.
# Usage: gh-issue-fields.sh <number>
if [[ $# -ne 1 ]]; then
  echo "Usage: gh-issue-fields.sh <number>" >&2
  exit 1
fi

"$(dirname "$0")/gh-issue-view.sh" "$1" | jq -r '
  "Title: \(.title)",
  "State: \(.state)",
  "Labels: \([.labels[].name] | join(", "))",
  "",
  .body
'
