Trigger this skill when the user mentions: view issue, show issue, open issue, read issue, fetch issue, display issue, gh issue view, issue details, or references an issue number to read or display.

# View Issue

Fetch and display a single GitHub issue with all comments.

## Steps

1. **Resolve the number** — use the number from the skill argument. If none was provided, ask the user for it.

2. **Fetch** — run exactly:
   ```
   gh issue view <number> --json number,title,state,labels,milestone,assignees,body,comments 2>&1
   ```
   Parse as JSON. If the command fails or returns empty output, tell the user and stop.

3. **Display** — render the issue in a readable format:

   ```
   #<number> — <title>
   State: <open|closed>   Labels: <label, ...>   Milestone: <name or —>

   <body>

   --- Comments (<count>) ---
   <for each comment: author, relative timestamp, body>
   ```

   Use relative timestamps (e.g. "3d ago"). If there are no comments, omit the comments section.

4. **Offer next steps** — after displaying:
   - `/kickoff <number>` to plan it
   - Mention any referenced issues or PRs found in the body

## Rules

- Never create, modify, or close issues — read-only.
- Always use the `--json` flag; never rely on the plain-text output format (it is inconsistent and sometimes empty).
- If the issue body references other issue numbers (e.g. `#10`), surface them as "Referenced: #10" so the user can follow up.
