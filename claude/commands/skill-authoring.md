Trigger this skill when the user asks to create, update, or improve a Claude Code skill (slash command).

## Creating a skill

Skills live in `~/.dotfiles/claude/commands/` and are symlinked to `~/.claude/commands/`. Always write to `~/.dotfiles/claude/commands/` — never directly to `~/.claude/commands/`.

After creating or updating a skill, commit and push in `~/.dotfiles`.

## Required: trigger words

Every skill file must start with a trigger line so the model knows when to invoke it automatically. Without this, the skill is only used when explicitly called with `/skill-name`.

Format:
```
Trigger this skill when the user mentions: <comma-separated keywords and phrases>.
```

Choose triggers that are specific enough to avoid false positives but broad enough to catch natural phrasing.

## File naming

Use kebab-case. The filename becomes the slash command (e.g. `tdd.md` → `/tdd`).
