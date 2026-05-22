#!/usr/bin/env bash
# PostToolUse hook: close GitHub issues referenced in git commit messages.
# Reads Claude's hook JSON from stdin, extracts the bash command,
# and closes any issues matched by closes/fixes/resolves #N.

set -euo pipefail

cmd=$(jq -r '.tool_input.command // ""')

# Only act on git commit invocations
echo "$cmd" | grep -qi 'git commit' || exit 0

# Extract issue numbers from closing keywords (case-insensitive)
issue_nums=$(echo "$cmd" | grep -oiE '(closes|fixes|resolves) #[0-9]+' | grep -oE '[0-9]+')

[ -z "$issue_nums" ] && exit 0

while IFS= read -r num; do
    env -u GITHUB_TOKEN gh issue close "$num" 2>/dev/null || true
done <<< "$issue_nums"
