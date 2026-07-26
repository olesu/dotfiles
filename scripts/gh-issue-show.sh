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

_gh issue view "$1" --comments
