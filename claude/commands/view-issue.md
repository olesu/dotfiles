Trigger this skill when the user mentions: view issue, show issue, open issue, read issue, fetch issue, display issue, gh issue view, issue details, dependency issue, referenced issue, look up issue, check issue, or references an issue number to read or display.

# View Issue

Fetch and display a single GitHub issue with all comments.

## Steps

1. **Detect the repo** — run `bash ~/.dotfiles/scripts/gh-repo-name.sh`.
   - Exit 0: one `<path>\t<owner/repo>` line. If `<path>` is `.`, cwd is already the repo. Otherwise every script call below must run from `<path>` (e.g. `cd <path> && bash ~/.dotfiles/scripts/gh-issue-view.sh <number>`).
   - Exit 2: multiple `<path>\t<owner/repo>` candidates (cwd is a multi-repo workspace root, not a repo itself). Ask the user which repo they mean, then treat their choice like the exit-0 case above.
   - Exit 1 or other failure: tell the user no GitHub repository was found here or in any subdirectory, and stop.

2. **Resolve the number** — use the number from the skill argument. If none was provided, ask the user for it.

3. **Fetch** — run (from the repo path resolved above):

   ```bash
   bash ~/.dotfiles/scripts/gh-issue-view.sh <number>
   ```

   Parse as JSON. If the command fails or returns empty output, tell the user and stop.

4. **Display** — render the issue in a readable format:

   ```text
   #<number> — <title>
   State: <open|closed>   Labels: <label, ...>   Milestone: <name or —>

   <body>

   --- Comments (<count>) ---
   <for each comment: author, relative timestamp, body>
   ```

   Use relative timestamps (e.g. "3d ago"). If there are no comments, omit the comments section.

5. **Offer next steps** — after displaying:
   - `/kickoff <number>` to plan it
   - Mention any referenced issues or PRs found in the body

## Rules

- Never create, modify, or close issues — read-only.
- If the issue body references other issue numbers (e.g. `#10`), surface them as "Referenced: #10" so the user can follow up.
