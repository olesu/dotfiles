Trigger this skill when the user mentions: list issues, show issues, prioritize issues, what issues, which issues, open issues, issue list, gh issues, what's next, whats next, what should I work on.

# List & Prioritize Issues

Fetch open GitHub issues for the current repo, prioritize them, and present a sorted list with a recommended next issue to work on.

## Steps

1. **Detect the repo(s)** — run `bash ~/.dotfiles/scripts/gh-repo-name.sh`.
   - Exit 0: one `<path>\t<owner/repo>` line. If `<path>` is `.`, cwd is already the repo. Otherwise every script call below must run from `<path>` (e.g. `cd <path> && bash ~/.dotfiles/scripts/gh-issue-list.sh`).
   - Exit 2: multiple `<path>\t<owner/repo>` candidates (cwd is a multi-repo workspace root, not a repo itself).
     - **First check for a project-specific combiner**: if a `Makefile` exists at cwd (the workspace root) with an `issues:` target (`grep -qE '^issues:' Makefile`), prefer it — run `make issues` and use its JSON output (expected: an array of issues, each already tagged with a `repo` field) directly for step 3, skipping step 2 and any per-repo scanning entirely. This avoids hand-rolling per-repo `cd`s, which has repeatedly raced when issued as parallel/sequential Bash calls (each Bash call gets its own cwd — a `cd` in one never carries into another, and relative `cd`s after an earlier call can resolve against the wrong directory).
     - Otherwise, auto-scan **all** candidates yourself — don't ask the user to pick. Run step 2 once per candidate, **each as its own Bash call using the candidate's full absolute path** (resolve `<path>` to absolute first — never chain a bare relative `cd <name>` across multiple calls), and tag each fetched issue with its `<owner/repo>` for the combined table.
   - Exit 1 or other failure: tell the user no GitHub repository was found here or in any subdirectory, and stop.

2. **Fetch open issues** — run (from the repo path resolved above; once per candidate repo when scanning multiple, skip entirely if step 1 already used `make issues`):

   ```bash
   bash ~/.dotfiles/scripts/gh-issue-list.sh
   ```

   Show all fetched issues by default — don't ask the user for label/milestone/assignee filters up front. Only filter if the user asks for it (in this run or a follow-up).

3. **Prioritize** — score each issue using these signals, in order of weight:
   1. **Priority/severity labels** — labels like `priority:high`, `critical`, `urgent`, `p0`/`p1` outrank everything else.
   2. **Bugs** — label contains "bug".
   3. **Recency** — most recently updated first, as a tiebreaker.

   Apply this ranking across the combined list from all scanned repos unless the user requests a different order (e.g. "sort by oldest", "just bugs").

4. **Present the list** — display as a markdown table with columns:

   | # | Title | Labels | Milestone | Updated | Comments |
   |---|-------|--------|-----------|---------|----------|

   When multiple repos were scanned, add a leading **Repo** column (`owner/repo`) so issues from different repos aren't ambiguous. Keep titles concise (truncate at ~60 chars if needed). Format the Updated column as relative time (e.g. "3d ago", "2w ago").

5. **Recommend a next issue** — after the table, call out the single top-priority issue by number and title, with a one-line reason drawn from the scoring signals above (e.g. "flagged `priority:high` and the most recently updated"). If several issues are close in priority, mention the top 2-3 instead of forcing a single pick.

6. **Offer next steps** — after the recommendation, offer:
   - `/kickoff <number>` to plan the recommended (or any) issue
   - Filter or re-sort (e.g. by label, milestone, assignee)

## Rules

- If there are no open issues (across all scanned repos), say so and stop.
- If a filter the user requests leaves zero issues, tell them and suggest loosening it.
- Never create, close, or modify issues during this skill — read-only.
- Don't fetch more than 100 issues per repo; if a repo has many issues and filtering would help, ask the user to filter before fetching.
