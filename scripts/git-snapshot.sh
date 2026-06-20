#!/usr/bin/env bash
set -euo pipefail

echo "=== git status ==="
git status

echo ""
echo "=== git diff ==="
git diff

echo ""
echo "=== git log --oneline -5 ==="
git log --oneline -5
