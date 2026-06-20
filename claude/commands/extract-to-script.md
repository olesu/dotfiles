Trigger this skill when the user mentions: extract to script, move to script, put in a script, script this out, shell script from skill, recurring command, bash into script.

Extract a recurring multi-step bash sequence from a skill (or conversation) into a reusable shell script in `~/.dotfiles/scripts/`, then update the skill to call the script instead.

## Why

Inline bash sequences in skills require a permission prompt for every individual command. A named script can be pre-approved once, and the logic becomes reusable and auditable.

## Steps

1. **Identify the source** — determine which skill file contains the sequence (check `~/.dotfiles/claude/commands/`) and which bash steps to extract. If the sequence is in the conversation rather than a file, use that.

2. **Name the script** — derive a kebab-case name from the skill name or the user's description (e.g. `gather-diff.sh`, `ship-dotfiles.sh`). Ask if ambiguous.

3. **Write the script** to `~/.dotfiles/scripts/<name>.sh`:
   - Shebang: `#!/usr/bin/env bash`
   - `set -euo pipefail` on the second line
   - Accept arguments via `$1`, `$2` etc. where the sequence has variable parts
   - Print a short header line so the caller can see what ran: `echo "=== <name> ==="`
   - Preserve the exact logic — no cleanup, no added error handling beyond what was in the original

4. **Make it executable**: `chmod +x ~/.dotfiles/scripts/<name>.sh`

5. **Update the skill file** — replace the inlined bash steps with a single call:
   ```
   Run `bash ~/.dotfiles/scripts/<name>.sh [args]`
   ```
   Keep surrounding context (step numbers, rules) intact.

6. **Commit and push** from `~/.dotfiles`:
   ```
   git add scripts/<name>.sh claude/commands/<skill>.md
   git commit -m "refactor(<scope>): extract <sequence description> into scripts/<name>.sh"
   git push
   ```

## Rules

- Always write to `~/.dotfiles/scripts/` — never directly to `~/.claude/` or `~/.local/`.
- Never alter the logic of the extracted sequence — only repackage it.
- If the sequence has hard-coded paths that should be arguments, make them arguments, but flag the change to the user.
- After pushing, remind the user to add `Bash(bash ~/.dotfiles/scripts/<name>.sh*)` to allowed-tools in settings if they want zero-prompt execution.
