Trigger this skill when the user mentions: kickoff, kick off issue, start issue, begin issue, plan issue, work on issue, or references a GitHub issue number to start working on.

# Issue Kickoff

A structured planning session that takes a GitHub issue from raw description to a concrete approach and test list, then writes the plan back to the issue as a reference for the implementation session.

## Steps

1. **Detect the repo** — run `bash ~/.dotfiles/scripts/gh-repo-name.sh` to confirm you're in a GitHub repo. If it exits non-zero, tell the user and stop.

2. **Fetch the issue** — run `bash ~/.dotfiles/scripts/gh-issue-view.sh <number>` to get the full issue including comments. If no number is provided, ask for it. If already in a plan comment on the issue, read it and pick up from there.

3. **Read project guidelines** — read the project's `CLAUDE.md` (and any files it references) to understand architecture, conventions, and constraints before planning.

4. **Clarify the requirement** — if anything in the issue is ambiguous, resolve it before moving to approach. Don't plan against a misread requirement.

5. **Plan together** — discuss until both agree on:
   - Where this fits in the existing architecture
   - The implementation approach
   - Edge cases and constraints that matter
   - What is explicitly out of scope

6. **Build the test list** — produce a numbered list of tests in the order they'd be written (TDD order: simplest behavior first). Each entry is one sentence describing what the test verifies. No code yet.

7. **Confirm** — present the approach and test list. Don't post to GitHub until the user is happy with it.

8. **Write the plan to the issue** — post a comment via `gh issue comment <number> --body "$(cat <<'EOF' ... EOF)"`. Use this format:

```
## Plan

<2–3 sentence summary of the approach>

## Decisions
- <decision or constraint>

## Test list
1. <behavior the test verifies>
2. ...

## Out of scope
- <item explicitly excluded>
```

## Rules

- No implementation code during this skill — planning only
- Keep the test list at the right altitude: one test per behavior, not one per line of code
- If the issue touches existing code, read the relevant files before proposing an approach
- After posting the plan, remind the user they can use `/tdd` during implementation and `/code-review` when done
