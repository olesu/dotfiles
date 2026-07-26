Trigger this skill when the user mentions: ship, commit and push, stage and push.

Stage all modified tracked files (and any confirmed untracked files), generate a commit message from the diff, commit, and push.

## Steps

1. Run `bash ~/.dotfiles/scripts/git-snapshot.sh` to get current status, diff, and recent log in one shot.
2. **Handle untracked files** — if `git status` shows untracked files, ask the user which ones to include. For each confirmed file, run `git add <path>` to stage it before committing. (`git-commit.sh` uses `git add -u`, which only stages already-tracked files — new files must be staged explicitly here.)
3. Check CLAUDE.md for an explicit note permitting pushes without confirmation (whether scoped to `main` or unconditional). If such a note exists and covers the current branch, proceed. Otherwise — regardless of branch — warn the user and ask for confirmation before continuing.
4. Draft a commit message from the diff (including any newly staged untracked files) following this repo's style (Conventional Commits: `<type>(<scope>): <message>`). If the change traces back to a GitHub issue (e.g. one planned via `/kickoff`), include a `Refs #<number>` (or `Closes #<number>` if it fully resolves it) line — this is what lets other tooling trace a commit back to its issue. Append the Co-Authored-By trailer:

```text
<type>(<scope>): <message>

Co-Authored-By: Claude <noreply@anthropic.com>
```

Before staging, check whether the repo has git hooks wired up (`git config --get core.hooksPath`, or look for `.git/hooks/pre-commit`/`pre-push` with real content). If it does, skip straight to the steps below — the hooks are the build/test gate, and `git-commit.sh`/`git-push.sh` invoke plain `git commit`/`git push`, so hooks fire automatically and a non-zero exit already means "stop, don't proceed."

If the repo has **no** hooks configured, run a manual build/test check first, before staging or committing anything: if the project has an Xcode workspace (check CLAUDE.md or look for `.xcodeproj`/`.xcworkspace`), run `mcp__xcode__BuildProject` then `mcp__xcode__RunAllTests` (get the tabIdentifier first via `mcp__xcode__XcodeListWindows`); for non-Xcode projects, run the appropriate build/typecheck and test command (e.g. `tsc --noEmit && npm test`, `cargo test`, `go test ./...`). If either fails, stop immediately and report the errors — do not stage or commit anything. Don't run this manual check when hooks are present — that would run the same build/test twice.

1. Run `bash ~/.dotfiles/scripts/git-commit.sh "<message>"` to stage tracked changes and commit. If a `pre-commit` hook is configured, it runs here — on failure, stop and report the errors; do not retry with `--no-verify`.
2. Run `bash ~/.dotfiles/scripts/git-push.sh` to push. If a `pre-push` hook is configured, it runs here — on failure, stop and report the errors; the commit stands locally but is not pushed.
3. Report the pushed commit hash and message.

## Rules

- Never use `--force` or `--no-verify`.
- If the build or tests fail — whether caught by a hook or the manual fallback check — abort. Do not commit broken code, and treat a failed push the same as a failed commit: stop and report, don't retry around it.
- If there is nothing to commit (no tracked changes and no confirmed untracked files), say so and stop.
- If CLAUDE.md says the repo is local-only, skip the push step.
