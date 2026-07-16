#!/usr/bin/env bash
set -euo pipefail

MESSAGE="${1:?Usage: git-commit.sh <commit-message>}"

git add -u
git commit -m "$MESSAGE"
