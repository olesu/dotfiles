# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal macOS dotfiles. Run `bash install.sh` to create all symlinks. iTerm2, zsh sourcing, and launchd loading are manual (instructions printed by the script).

**Symlink targets (managed by `install.sh`):**

- `nvim/` → `~/.config/nvim`
- `tmux/tmux.conf` → `~/.tmux.conf`
- `starship/starship.toml` → `~/.config/starship.toml`
- `gitmux/gitmux.conf` → `~/.gitmux.conf`
- `git/gitconfig` → `~/.gitconfig`
- `lazygit/config.yml` → `~/.config/lazygit/config.yml`
- `claude/settings.json` → `~/.claude/settings.json`
- `claude/CLAUDE.md` → `~/.claude/CLAUDE.md`
- `claude/scripts/*.sh` → `~/.claude/scripts/*.sh` (individual file symlinks)
- `claude/commands/*.md` → `~/.claude/commands/*.md` (individual file symlinks)
- `claude/agents/*.md` → `~/.claude/agents/*.md` (individual file symlinks)
- `launchd/*.plist` → `~/Library/LaunchAgents/*.plist`
- `bin/gh` → `~/.local/bin/gh` (wrapper script — see `bin/` below)
- `zsh/zshrc.zsh` — sourced from `~/.zshrc` (not a symlink; added manually)
- `iterm2/` — iTerm2 reads via *Settings → General → Preferences → Load preferences from a custom folder*

## Common Commands

```bash
# Install all Homebrew dependencies
brew bundle

# Reload zsh config
exec zsh

# Profile zsh startup time
zsh -i -c exit

# Rebuild antidote plugin bundle
antidote bundle

# Install/update Neovim plugins (inside Neovim)
:Lazy sync

# Install TPM tmux plugins (inside tmux)
prefix + I   # prefix is Ctrl-a

# Reload tmux config
prefix + r
```

## Architecture

### Zsh (`zsh/`)

Modular config sourced by `zshrc.zsh`:

- `env.zsh` — environment variables (FZF, Python venv path, iTerm integration)
- `aliases.zsh` — minimal aliases (`bat` as `cat`, `cless` as `less`)
- `functions.zsh` — custom functions: `mkcd`, `extract`, `dev`, `commit`
- `plugins.zsh` — Antidote loader
- `zsh_plugins.txt` — Antidote plugin manifest (Oh My Zsh plugins + zsh-users plugins)

The `dev()` function jumps to a project directory, activates venv if present, and creates/attaches a tmux session. The `commit()` function is an interactive conventional commit helper.

### Neovim (`nvim/`)

Built on **LazyVim** framework. `init.lua` bootstraps `lua/config/lazy.lua`.

**Config layer** (`lua/config/`):

- `lazy.lua` — LazyVim setup with extras (Copilot, TypeScript, Python, Telescope, Prettier, Neotest, etc.)
- `options.lua` — sets Python venv path to `.dotfiles/.venv`
- `keymaps.lua` — minimal additions (jk → ESC)
- `autocmds.lua` — auto-detects project venvs for Python files

**Plugin overrides** (`lua/plugins/`): One file per plugin — each overrides or extends a single LazyVim plugin spec. Check `ls lua/plugins/` for the current list.

### Tmux (`tmux/`)

Prefix is `Ctrl-a`. Vim-tmux-navigator enables seamless `Ctrl-hjkl` navigation between Neovim splits and tmux panes. TPM manages plugins; auto-installs if missing.

### Starship (`starship/`)

Catppuccin Mocha theme. Single `starship.toml` config.

### Python venv (`.venv/`)

Used exclusively for Neovim's Python provider (`pynvim`). Path is hardcoded in `nvim/lua/config/options.lua`.

## Git workflow

This is a personal repo — pushing directly to `main` is the normal workflow. Use the `/ship` skill to stage, commit, and push in one step.

### launchd (`launchd/`)

Scheduled macOS agents loaded via `~/Library/LaunchAgents/`. Setup for each plist:

```bash
ln -sf ~/.dotfiles/launchd/<name>.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/<name>.plist
```

Current agents:
- `com.olesu.update-claude-code.plist` — daily at 09:00, `brew upgrade claude-code`
- `com.olesu.janitor.plist` — Mondays at 09:00, full brew maintenance via `scripts/janitor.sh`

Logs land in `~/Library/Logs/`.

### Scripts (`scripts/`)

Shell scripts called by launchd agents or run manually.

- `janitor.sh` — runs `brew update`, `brew upgrade`, `brew autoremove`, `brew cleanup`, `brew doctor`
- `supply_chain_check.sh` — verifies integrity of supply chain pins
- `lib.sh` — shared helpers; source this in any script that needs `_gh()` (calls `$HOME/.local/bin/gh` directly to bypass PATH ordering issues in Claude Code's bash environment)
- `gh-repo-name.sh` — prints `owner/repo` for the current directory; exits non-zero with a message if not in a GitHub repo
- `gh-issue-list.sh` — fetches open issues as JSON (`--limit 100`); accepts optional `--limit N`
- `gh-issue-view.sh <number>` — fetches a single issue as JSON including comments

### Claude skills (`claude/commands/`)

Slash commands available in any Claude Code session. Symlinked to `~/.claude/commands/`.

**GitHub issue workflow:**
- `/list-issues` — fetch open issues, filter by label/milestone/assignee, display sorted table
- `/view-issue <number>` — fetch and render a single issue with comments
- `/kickoff <number>` — structured planning session: discuss approach, build test list, post plan as issue comment

**Development workflow:**
- `/ship` — stage, commit (Conventional Commits), and push in one step
- `/tdd` — red-green-refactor loop guide
- `/code-review` — review current diff for bugs and cleanup opportunities

**Project setup:**
- `/xcode-setup` — verify Xcode MCP is wired up correctly
- `/playwright-setup` — add Playwright e2e testing to a native project
- `/swift-lsp` — configure SourceKit-LSP for Swift projects
- `/swift-tech-lead` — plan then hand off to Haiku for Swift implementation

**Dotfiles maintenance:**
- `/janitor` — run brew maintenance and system cleanup
- `/skill-authoring` — scaffold a new skill file with correct format and triggers
- `/extract-to-script` — move inline bash logic into `scripts/`
- `/import-claude-config` — import settings from `~/.claude` into dotfiles
- `/scope-plugins` — move a Claude plugin from global to project scope

### Bin wrappers (`bin/`)

Personal binary wrappers symlinked into `~/.local/bin/` (which is in `$PATH` ahead of Homebrew).

- `gh` — wraps `/opt/homebrew/bin/gh`: unsets `GITHUB_TOKEN` before calling `op plugin run`, so Claude Code's injected token (which is often stale) doesn't override 1Password credentials.

## Conventions

- **Conventional Commits**: `<type>(<scope>): <message>` — scopes match directory names (zsh, nvim, tmux, starship)
- **Neovim plugins**: add new plugin specs as individual files in `lua/plugins/`
- **Zsh additions**: new shell functions go in `functions.zsh`, new aliases in `aliases.zsh`
- The `nvim/lazy-lock.json` is the Neovim plugin lockfile — commit updates after `:Lazy sync`
