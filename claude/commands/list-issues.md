Trigger this skill when the user mentions: list issues, show issues, prioritize issues, what issues, which issues, open issues, issue list, gh issues.

# List & Prioritize Issues

Fetch open GitHub issues for the current repo, let the user filter interactively, and present a sorted list to help decide what to work on next.

## Steps

1. **Detect the repo** — run `bash ~/.dotfiles/scripts/gh-repo-name.sh` to confirm you're in a GitHub repo. If it exits non-zero, tell the user and stop.

2. **Fetch open issues** — run:
   ```
   bash ~/.dotfiles/scripts/gh-issue-list.sh
   ```

3. **Ask the user for filters** (present all at once, default to "no filter" for each):
   - **Label** — list the unique labels present in the fetched issues and ask which to include (or none to show all)
   - **Milestone** — list milestones present (or none to show all)
   - **Assignee** — include only issues assigned to the user, unassigned, or all?

4. **Apply filters** — filter the fetched issue list in memory; no additional `gh` calls needed.

5. **Sort** — default sort is: **bugs first** (label contains "bug"), then by **most recently updated** descending. Apply this unless the user requests a different order.

6. **Present the list** — display as a markdown table with columns:

   | # | Title | Labels | Milestone | Updated | Comments |
   |---|-------|--------|-----------|---------|----------|

   Keep titles concise (truncate at ~60 chars if needed). Format the Updated column as relative time (e.g. "3d ago", "2w ago").

7. **Offer next steps** — after the list, offer:
   - `/kickoff <number>` to plan an issue
   - Re-run with different filters

## Rules

- If there are no open issues, say so and stop.
- If the issue count after filtering is zero, tell the user and suggest loosening the filters.
- Never create, close, or modify issues during this skill — read-only.
- Don't fetch more than 100 issues; if the repo has many issues and filtering would help, ask the user to filter before fetching.
