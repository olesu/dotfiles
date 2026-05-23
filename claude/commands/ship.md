Trigger this skill when the user mentions: ship, commit and push, stage and push.

Stage all modified tracked files, generate a commit message from the diff, commit, and push.

## Steps

1. Run `git status` and `git diff` in parallel to understand what will be committed.
2. Check the current branch — if it is `main`, check CLAUDE.md for an explicit note permitting pushes to main. If found, proceed. If not, warn the user and ask for confirmation before continuing.
3. Stage tracked changes: `git add -u`
4. Draft a commit message from the diff following this repo's style (look at recent `git log --oneline -5` for conventions).
5. Commit with the Co-Authored-By trailer:
```
git commit -m "$(cat <<'EOF'
<message>

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
EOF
)"
```
6. Push: `git push`
7. Report the pushed commit hash and message.

## Rules

- Never use `--force` or `--no-verify`.
- If there are untracked files, ask whether to include them before proceeding.
- If there is nothing to commit, say so and stop.
- If CLAUDE.md says the repo is local-only, skip the push step.
