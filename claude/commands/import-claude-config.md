Trigger this skill when the user mentions: import claude config, import from ~/.claude, move to dotfiles, track claude config, import into this repository, symlink from this repository, add to dotfiles, track in dotfiles.

Import a file or directory from `~/.claude` into the dotfiles repo and replace the original with a symlink.

## Steps

1. Identify the target — the file or directory in `~/.claude` the user wants to import. If not specified, run `ls -la ~/.claude` and compare against existing symlinks to show what isn't yet tracked.
2. Check if the target is already a symlink pointing into the dotfiles. If so, say so and stop.
3. Determine the destination path in the dotfiles: `~/.dotfiles/claude/<name>` (preserve the filename/dirname).
4. Copy the target into the dotfiles:
   - File: `cp ~/.claude/<name> ~/.dotfiles/claude/<name>`
   - Directory: `cp -r ~/.claude/<name> ~/.dotfiles/claude/<name>`
5. Remove the original and create the symlink:
   ```bash
   rm -rf ~/.claude/<name>
   ln -s ~/.dotfiles/claude/<name> ~/.claude/<name>
   ```
6. Verify: `ls -la ~/.claude/<name>` — confirm it shows as a symlink to the dotfiles path.
7. Update `~/.dotfiles/CLAUDE.md` — add a line to the **Symlink targets** list:
   - File: `` `claude/<name>` → `~/.claude/<name>` ``
   - Directory: `` `claude/<name>/` → `~/.claude/<name>` ``
8. Commit and push using the `/ship` skill.

## Rules

- Always write to `~/.dotfiles/claude/` — never directly to `~/.claude/`.
- Symlink direction is always dotfiles → `~/.claude`, never the reverse.
- Directories are symlinked whole (like `commands/` and `agents/`), not file-by-file.
- If the dotfiles destination already exists, stop and warn before overwriting.
