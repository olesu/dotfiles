#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=scripts/lib.sh
source "$(dirname "$0")/lib.sh"

# Fetches the current repo's labels as JSON.
# Usage: gh-label-list.sh
_gh label list --json name,description --limit 100
