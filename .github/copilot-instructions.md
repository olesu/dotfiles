# Copilot Instructions for Dotfiles

Personalized workstation configuration repository for macOS with Neovim, Tmux, and Zsh.

## Code Style

### Lua (Neovim)
- **Formatter**: stylua (configured in [nvim/stylua.toml](nvim/stylua.toml))
- **Settings**: 2-space indents, 120 column width
- **Structure**: LazyVim plugin-based with modular config files in `nvim/lua/`
  - `config/` - Core configuration (options, keymaps, autocmds, lazy setup)
  - `plugins/` - Plugin specs and customizations
- **Plugin specs**: Use LazyVim's `opts` pattern for configuration (see [nvim/lua/plugins/](nvim/lua/plugins/))

### Bash/Zsh
- **Shell**: Zsh with Antidote plugin manager
- **Modular approach**: Separate thematic files (env.zsh, aliases.zsh, functions.zsh, plugins.zsh)
- **Config location**: `~/.dotfiles/zsh/` sourced via `ZSH_CONFIG_DIR` in `~/.zshrc`
- **Plugin bundles**: [zsh/zsh_plugins.txt](zsh/zsh_plugins.txt) managed by Antidote

## Architecture

```
~/.dotfiles/
├── nvim/              → symlink to ~/.config/nvim (LazyVim)
│   ├── lua/
│   │   ├── config/    (options, keymaps, autocmds, lazy.lua)
│   │   └── plugins/   (plugin specs, colorscheme, python, etc)
│   └── lazy-lock.json (plugin versions)
├── tmux/
│   └── tmux.conf      → symlink to ~/.tmux.conf
├── zsh/               → sourced in ~/.zshrc via ZSH_CONFIG_DIR
│   ├── zshrc.zsh      (entry point, modular loader)
│   ├── env.zsh        (environment variables, FZF, Python)
│   ├── plugins.zsh    (Antidote setup and plugin options)
│   ├── aliases.zsh    (shell aliases)
│   ├── functions.zsh  (custom shell functions)
│   └── zsh_plugins.txt (Antidote bundle)
├── .venv/             (Python venv with pynvim for Neovim)
└── README.md          (setup instructions)
```

### Key Design Decisions
1. **Symlinks** point FROM system locations TO dotfiles repo, enabling version control
2. **Python venv separation**:
   - `~/.dotfiles/.venv` - Neovim provider only (requires pynvim)
   - Project `.venv` (auto-detected by LSP via [nvim/lua/config/autocmds.lua](nvim/lua/config/autocmds.lua))
3. **Modular Zsh** - Each concern in separate file, sourced by zshrc.zsh if present
4. **LazyVim extras** - Predefined plugin sets in [nvim/lazyvim.json](nvim/lazyvim.json)

## Setup

### Initial Setup
```bash
cd ~/.dotfiles
python3 -m venv .venv && source .venv/bin/activate && pip install pynvim
ln -sf ~/.dotfiles/nvim ~/.config/nvim
ln -sf ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf
# Add to ~/.zshrc: export ZSH_CONFIG_DIR="$HOME/.dotfiles/zsh"; source "$ZSH_CONFIG_DIR/zshrc.zsh"
```

### Python Virtual Environment
The dotfiles `.venv` is **exclusively for Neovim's python3_host_prog** (configured in [nvim/lua/config/options.lua](nvim/lua/config/options.lua)).

After creating `.venv`, always install pynvim:
```bash
source ~/.dotfiles/.venv/bin/activate
pip install --upgrade pip pynvim
```

## Project Conventions

### Neovim
- **Python provider**: Always use `~/.dotfiles/.venv/bin/python` (has pynvim)
- **Project detection**: Autocmd in [nvim/lua/config/autocmds.lua](nvim/lua/config/autocmds.lua) detects `.venv` and sets `VIRTUAL_ENV/PATH` for LSP tools
- **LSP servers**: Configured via plugin specs in `nvim/lua/plugins/`, auto-installed by Mason
- **Theme**: Catppuccin (mocha flavor) via [nvim/lua/plugins/colorscheme.lua](nvim/lua/plugins/colorscheme.lua)
- **Plugin style**: Prefer LazyVim extras (in [nvim/lazyvim.json](nvim/lazyvim.json)) over custom plugins

### Tmux
- **Prefix**: `Ctrl-a` (remapped via [tmux/tmux.conf](tmux/tmux.conf), line 7)
- **Plugins**: Managed by TPM (auto-installs on first load)
- **Theme**: Catppuccin mocha via `@plugin 'catppuccin/tmux'`
- **Navigation**: vim-tmux-navigator enabled for seamless Neovim ↔ Tmux pane movement (Ctrl-hjkl)
- **Numbering**: Windows and panes start at 1 (not 0) - set via `base-index` and `pane-base-index`

### Zsh
- **Plugin manager**: Antidote (loaded in [zsh/plugins.zsh](zsh/plugins.zsh))
- **Bundle file**: [zsh/zsh_plugins.txt](zsh/zsh_plugins.txt) - add plugins there, not in code
- **Auto-load**: New config files in `zsh/` with `*.zsh` extension auto-source if found
- **Environment**: Store env vars in [zsh/env.zsh](zsh/env.zsh), aliases in [zsh/aliases.zsh](zsh/aliases.zsh)

## Integration Points

### Neovim ↔ Tmux
- **vim-tmux-navigator** plugin ([nvim/lua/plugins/vim-tmux-navigator.lua](nvim/lua/plugins/vim-tmux-navigator.lua))
  - Ctrl-hjkl navigate between Neovim splits AND Tmux panes seamlessly
  - Requires Tmux prefix binding `bind C-a send-prefix` (already configured)

### Python in Neovim
- **Provider**: [nvim/lua/config/options.lua](nvim/lua/config/options.lua) sets `python3_host_prog` to `~/.dotfiles/.venv/bin/python`
- **Project detection**: [nvim/lua/config/autocmds.lua](nvim/lua/config/autocmds.lua) finds project `.venv` on BufEnter for Python files
- **LSP venv**: [nvim/lua/plugins/python.lua](nvim/lua/plugins/python.lua) configures pyright to detect venvPath/pythonPath

### Zsh Integration
- Antidote loads all plugins from [zsh/zsh_plugins.txt](zsh/zsh_plugins.txt)
- Plugin options set in [zsh/plugins.zsh](zsh/plugins.zsh) (e.g., eza icons, colorize style)
- Python plugin auto-activates `.venv` in directories (via `PYTHON_AUTO_VRUN` in [zsh/env.zsh](zsh/env.zsh))

## Important Notes

### When Adding Plugins
1. **Neovim**: Add to plugin spec in `nvim/lua/plugins/` (lazy-load preferred)
2. **Tmux**: Add to [tmux/tmux.conf](tmux/tmux.conf) as `set -g @plugin 'owner/name'`, must be before `run-shell... tpm`
3. **Zsh**: Add to [zsh/zsh_plugins.txt](zsh/zsh_plugins.txt), run `antidote bundle && restart shell`

### When Modifying Configuration
- Changes to `nvim/lua/` take effect on next Neovim restart
- Changes to `tmux/tmux.conf` require `tmux source-file ~/.tmux.conf` or `kill-server` for major changes
- Changes to `zsh/` files require `exec zsh` or terminal restart

### Virtual Environment Awareness
- `.venv` in dotfiles = Neovim only, has pynvim
- `.venv` in project = LSP/tools only, auto-detected
- Never mix them - LSP should NOT use Neovim's provider venv

## Git Workflow

**Important**: Do NOT commit changes unless explicitly asked. Stage changes and report what was done, then wait for the user to request a commit. This allows the user to review and decide when to commit.

**Formatting**: Before staging any file, format it using VS Code's formatter (`editor.action.formatDocument`) to ensure consistent style. This applies to Markdown, Lua, shell scripts, and all other file types.
