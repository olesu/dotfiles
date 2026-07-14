Trigger this skill when the user mentions: list issues, show issues, prioritize issues, what issues, which issues, open issues, issue list, gh issues.

# List & Prioritize Issues

Fetch open GitHub issues for the current repo, let the user filter interactively, and present a sorted list to help decide what to work on next.

## Steps

1. **Detect the repo(s)** — run `bash ~/.dotfiles/scripts/gh-repo-name.sh`.
   - Exit 0: one `<path>\t<owner/repo>` line. If `<path>` is `.`, cwd is already the repo. Otherwise every script call below must run from `<path>` (e.g. `cd <path> && bash ~/.dotfiles/scripts/gh-issue-list.sh`).
   - Exit 2: multiple `<path>\t<owner/repo>` candidates (cwd is a multi-repo workspace root, not a repo itself). Auto-scan **all** candidates — don't ask the user to pick. Run step 2 once per candidate, from its own `<path>`, and tag each fetched issue with its `<owner/repo>` for the combined table.
   - Exit 1 or other failure: tell the user no GitHub repository was found here or in any subdirectory, and stop.

2. **Fetch open issues** — run (from the repo path resolved above; once per candidate repo when scanning multiple):
   ```
   bash ~/.dotfiles/scripts/gh-issue-list.sh
   ```

3. **Ask the user for filters** (present all at once, default to "no filter" for each):
   - **Label** — list the unique labels present across all fetched issues and ask which to include (or none to show all)
   - **Milestone** — list milestones present across all fetched issues (or none to show all)
   - **Assignee** — include only issues assigned to the user, unassigned, or all?

4. **Apply filters** — filter the combined fetched issue list in memory; no additional `gh` calls needed.

5. **Sort** — default sort is: **bugs first** (label contains "bug"), then by **most recently updated** descending, across the combined list from all scanned repos. Apply this unless the user requests a different order.

6. **Present the list** — display as a markdown table with columns:

   | # | Title | Labels | Milestone | Updated | Comments |
   |---|-------|--------|-----------|---------|----------|

   When multiple repos were scanned, add a leading **Repo** column (`owner/repo`) so issues from different repos aren't ambiguous. Keep titles concise (truncate at ~60 chars if needed). Format the Updated column as relative time (e.g. "3d ago", "2w ago").

7. **Offer next steps** — after the list, offer:
   - `/kickoff <number>` to plan an issue
   - Re-run with different filters

## Rules

- If there are no open issues (across all scanned repos), say so and stop.
- If the issue count after filtering is zero, tell the user and suggest loosening the filters.
- Never create, close, or modify issues during this skill — read-only.
- Don't fetch more than 100 issues per repo; if a repo has many issues and filtering would help, ask the user to filter before fetching.
