Trigger this skill when the user mentions: ship, commit and push, stage and push.

Stage all modified tracked files, generate a commit message from the diff, commit, and push.

## Steps

1. **Build and test check** — if the project has an Xcode workspace (check CLAUDE.md or look for `.xcodeproj`/`.xcworkspace`), run `mcp__xcode__BuildProject` then `mcp__xcode__RunAllTests` (get the tabIdentifier first via `mcp__xcode__XcodeListWindows`). If either fails, **stop immediately** and report the errors — do not stage or commit anything. For non-Xcode projects, run the appropriate build/typecheck and test command instead (e.g. `tsc --noEmit && npm test`, `cargo test`, `go test ./...`).
2. Run `bash ~/.dotfiles/scripts/git-snapshot.sh` to get current status, diff, and recent log in one shot.
3. Read the branch from the snapshot output. If it is `main`, check CLAUDE.md for an explicit note permitting pushes to main. If found, proceed. If not, warn the user and ask for confirmation before continuing.
4. Draft a commit message from the diff following this repo's style (Conventional Commits: `<type>(<scope>): <message>`). Append the Co-Authored-By trailer:
```
<type>(<scope>): <message>

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
```
5. Run `bash ~/.dotfiles/scripts/git-commit-push.sh "<message>"` to stage, commit, and push.
6. Report the pushed commit hash and message.

## Rules

- Never use `--force` or `--no-verify`.
- If the build or tests fail, abort — do not commit broken code.
- If there are untracked files, ask whether to include them before proceeding.
- If there is nothing to commit, say so and stop.
- If CLAUDE.md says the repo is local-only, skip the push step.
