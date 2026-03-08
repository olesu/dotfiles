# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal macOS dotfiles managed via manual symlinks. No install scripts — setup is documented in README.md and done manually.

**Symlink targets:**
- `nvim/` → `~/.config/nvim`
- `tmux/tmux.conf` → `~/.tmux.conf`
- `starship/starship.toml` → `~/.config/starship.toml`
- `zsh/zshrc.zsh` sourced from `~/.zshrc`

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

**Plugin overrides** (`lua/plugins/`): Each file overrides or adds a single plugin — harpoon, lazygit, lualine (with Copilot status), vim-tmux-navigator, python (Pyright), colorscheme (Catppuccin Mocha), neotest (Vitest adapter), ui (indent-blankline).

### Tmux (`tmux/`)
Prefix is `Ctrl-a`. Vim-tmux-navigator enables seamless `Ctrl-hjkl` navigation between Neovim splits and tmux panes. TPM manages plugins; auto-installs if missing.

### Starship (`starship/`)
Catppuccin Mocha theme. Single `starship.toml` config.

### Python venv (`.venv/`)
Used exclusively for Neovim's Python provider (`pynvim`). Path is hardcoded in `nvim/lua/config/options.lua`.

## Conventions

- **Conventional Commits**: `<type>(<scope>): <message>` — scopes match directory names (zsh, nvim, tmux, starship)
- **Neovim plugins**: add new plugin specs as individual files in `lua/plugins/`
- **Zsh additions**: new shell functions go in `functions.zsh`, new aliases in `aliases.zsh`
- The `lazy-lock.json` at repo root is the Neovim plugin lockfile — commit updates after `:Lazy sync`
