#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=scripts/lib.sh
source "$(dirname "$0")/lib.sh"

# Creates a GitHub issue. Body is read from stdin. Prints the created issue
# URL on success.
# Usage: gh-issue-create.sh <title> [label...]
if [[ $# -lt 1 ]]; then
  echo "Usage: gh-issue-create.sh <title> [label...]" >&2
  exit 1
fi

title="$1"
shift

label_args=()
for label in "$@"; do
  label_args+=(--label "$label")
done

_gh issue create --title "$title" --body-file - "${label_args[@]}"
