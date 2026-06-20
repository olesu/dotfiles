# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal macOS dotfiles managed via manual symlinks. No install scripts — setup is documented in README.md and done manually.

**Symlink targets:**

- `nvim/` → `~/.config/nvim`
- `tmux/tmux.conf` → `~/.tmux.conf`
- `starship/starship.toml` → `~/.config/starship.toml`
- `zsh/zshrc.zsh` sourced from `~/.zshrc`
- `claude/commands/` → `~/.claude/commands`
- `claude/agents/` → `~/.claude/agents`
- `claude/scripts/statusline.sh` → `~/.claude/scripts/statusline.sh`
- `claude/scripts/tmux_status_claude.sh` → `~/.claude/scripts/tmux_status_claude.sh`
- `claude/settings.json` → `~/.claude/settings.json`
- `claude/CLAUDE.md` → `~/.claude/CLAUDE.md`
- `git/gitconfig` → `~/.gitconfig`
- `lazygit/config.yml` → `~/.config/lazygit/config.yml`
- `launchd/*.plist` → `~/Library/LaunchAgents/` (symlink each, then load with `launchctl load`)
- `iterm2/` → iTerm2 reads this via *Settings → General → Preferences → Load preferences from a custom folder* (set to `~/.dotfiles/iterm2/`). Saves as XML plist — human-readable and diffable in git.
- `gitmux/gitmux.conf` → `~/.gitmux.conf` (required by the Catppuccin tmux gitmux module; minimal file that uses all gitmux defaults)

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
- `functions.zsh` — custom functions: `mkcd`, `extract`, `gcp`, `dev`, `commit`
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

## Conventions

- **Conventional Commits**: `<type>(<scope>): <message>` — scopes match directory names (zsh, nvim, tmux, starship)
- **Neovim plugins**: add new plugin specs as individual files in `lua/plugins/`
- **Zsh additions**: new shell functions go in `functions.zsh`, new aliases in `aliases.zsh`
- The `nvim/lazy-lock.json` is the Neovim plugin lockfile — commit updates after `:Lazy sync`
