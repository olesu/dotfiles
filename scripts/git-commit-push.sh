#!/usr/bin/env bash
set -euo pipefail

MESSAGE="${1:?Usage: git-commit-push.sh <commit-message>}"

git add -u
git commit -m "$MESSAGE"
git push
