#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=scripts/lib.sh
source "$(dirname "$0")/lib.sh"

# Renders a single GitHub issue for reading (native gh formatting, with
# comments) — the human-readable companion to gh-issue-view.sh, which returns
# JSON for programmatic field extraction.
# Usage: gh-issue-show.sh <number>
if [[ $# -ne 1 ]]; then
  echo "Usage: gh-issue-show.sh <number>" >&2
  exit 1
fi

# `gh issue view --comments` prints ONLY the comment threads in non-TTY mode
# (any script) — and nothing at all when the issue has no comments yet, which
# is exactly the freshly-filed-then-read case at kickoff. Show the issue body
# first, then append comments (a no-op when there are none).
_gh issue view "$1"
_gh issue view "$1" --comments
