#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=scripts/lib.sh
source "$(dirname "$0")/lib.sh"

# Advisory check for FlexLoan's paired cross-repo issue convention: warns if
# the commit being pushed references an issue whose linked issue in the other
# FlexLoan repo is still open. Never blocks — this is a nudge, not a gate,
# since the issue-number heuristic below has false negatives (e.g. a commit
# message with no "#N" reference just skips the check silently).
#
# Usage: check-paired-issue.sh "<commit message>"

MESSAGE="${1:-}"

ISSUE_NUM=$(grep -oE '#[0-9]+' <<< "$MESSAGE" | head -1 | tr -d '#') || true
if [[ -z "$ISSUE_NUM" ]]; then
  exit 0
fi

REPO=$(_gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null) || exit 0

case "$REPO" in
  olesu/flexloan) OTHER_REPO="olesu/flexloan-api" ;;
  olesu/flexloan-api) OTHER_REPO="olesu/flexloan" ;;
  *) exit 0 ;;
esac

BODY=$(_gh issue view "$ISSUE_NUM" --repo "$REPO" --json body,comments \
  -q '.body + " " + ([.comments[].body] | join(" "))' 2>/dev/null) || exit 0

PAIRED_NUM=$(grep -oE "${OTHER_REPO}/issues/[0-9]+" <<< "$BODY" | head -1 | grep -oE '[0-9]+$') || true
if [[ -z "$PAIRED_NUM" ]]; then
  exit 0
fi

PAIRED_STATE=$(_gh issue view "$PAIRED_NUM" --repo "$OTHER_REPO" --json state -q .state 2>/dev/null) || exit 0

if [[ "$PAIRED_STATE" == "OPEN" ]]; then
  echo "⚠ Paired issue ${OTHER_REPO}#${PAIRED_NUM} (linked from ${REPO}#${ISSUE_NUM}) is still open — this contract change may be landing one-sided."
fi
