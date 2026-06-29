#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=scripts/lib.sh
source "$(dirname "$0")/lib.sh"

# Fetches a single GitHub issue as JSON.
# Usage: gh-issue-view.sh <number>
if [[ $# -ne 1 ]]; then
  echo "Usage: gh-issue-view.sh <number>" >&2
  exit 1
fi

_gh issue view "$1" \
  --json number,title,state,labels,milestone,assignees,body,comments
