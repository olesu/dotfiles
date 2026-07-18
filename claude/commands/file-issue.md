Trigger this skill when the user mentions: file issue, file a bug, create issue, new issue, open an issue, report a bug, log an issue.

# File an Issue

Draft and create a new GitHub issue for the current repo, applying labels that already exist in the repo where they fit.

## Steps

1. **Detect the repo** — run `bash ~/.dotfiles/scripts/gh-repo-name.sh`.
   - Exit 0: one `<path>\t<owner/repo>` line. If `<path>` is `.`, cwd is already the repo. Otherwise every script call below must run from `<path>`.
   - Exit 2: multiple candidates. Unlike `/list-issues`, this skill can't auto-scan — filing needs one target repo. List the candidates and ask the user which one to file into.
   - Exit 1 or other failure: tell the user no GitHub repository was found here or in any subdirectory, and stop.

2. **Draft title and body** — if the user's request already contains enough detail, draft a concise title and a short body (for bugs: what's broken, repro steps if given, expected vs actual; for features: what and why) yourself. If key details are missing, ask one round of clarifying questions — don't interrogate.

3. **Fetch existing labels** — run (from the resolved repo path):

   ```bash
   bash ~/.dotfiles/scripts/gh-label-list.sh
   ```

4. **Propose labels** — match the drafted issue against the fetched labels' names/descriptions (e.g. a defect report → `bug`, a feature request → `enhancement`, docs-only → `documentation`). Only propose labels that actually exist in this repo's fetched list — never invent new ones or assume labels from other repos exist here. If nothing fits well, propose no labels rather than forcing a weak match.

5. **Confirm before creating** — show the user the draft title, body, and proposed labels together and get explicit confirmation (or edits) before creating anything. Never file an issue without this confirmation step.

6. **Create the issue** — from the resolved repo path, pipe the body to:

   ```bash
   bash ~/.dotfiles/scripts/gh-issue-create.sh "<title>" [label...]
   ```

   (body goes via stdin, e.g. `printf '%s\n' "$body" | bash ~/.dotfiles/scripts/gh-issue-create.sh "<title>" label1 label2`)

7. **Report the result** — the script prints the created issue's URL; share it, and offer `/kickoff <number>` to start planning it now.

## Rules

- Always get explicit confirmation of title, body, and labels before creating — this is the one write action in the issue-workflow skills, so don't skip the check.
- Only apply labels that exist in the target repo already.
- Never edit, close, or comment on other issues during this skill.
