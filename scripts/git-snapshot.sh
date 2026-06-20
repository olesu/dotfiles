#!/usr/bin/env bash
set -euo pipefail

echo "=== branch ==="
git branch --show-current

echo ""
echo "=== git status ==="
git status

echo ""
echo "=== git diff ==="
git diff

echo ""
echo "=== git log --oneline -5 ==="
git log --oneline -5
