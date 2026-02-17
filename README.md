# Dotfiles

Personal macOS workstation configuration for Neovim, Tmux, and Zsh.

## Prerequisites

Install all required tools using the Brewfile:

```bash
cd ~/.dotfiles
brew bundle
```

Or install individually:

```bash
brew install git-delta jq yq zoxide lazygit fzf ripgrep fd bat eza antidote starship tmux neovim
```

## Setup

1. Clone and enter the repository:

   ```bash
   git clone <your-repo-url> ~/.dotfiles
   cd ~/.dotfiles
   ```

2. Create Python virtual environment with pynvim:

   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   pip install --upgrade pip pynvim
   ```

3. Create symlinks:

   ```bash
   ln -sf ~/.dotfiles/nvim ~/.config/nvim
   ln -sf ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf
   ln -sf ~/.dotfiles/starship/starship.toml ~/.config/starship.toml
   ```

4. Configure Zsh by adding this to `~/.zshrc`:

   ```bash
   export ZSH_CONFIG_DIR="${HOME}/.dotfiles/zsh"
   source "${ZSH_CONFIG_DIR}/zshrc.zsh"
   ```

5. Reload shell:

   ```bash
   exec zsh
   ```

## What's Inside

- **nvim/** - Neovim config (LazyVim) symlinked to `~/.config/nvim`
- **tmux/** - Tmux config symlinked to `~/.tmux.conf`
- **starship/** - Starship prompt config symlinked to `~/.config/starship.toml`
- **zsh/** - Zsh configuration with Antidote plugin manager
- **.venv/** - Python virtual environment for Neovim (has pynvim)
- **Brewfile** - Homebrew dependencies for reproducible setup

## Features

### Modern CLI Tools
- **zoxide** - Smart `cd` with frecency-based directory jumping (`z` command)
- **lazygit** - Beautiful terminal UI for git operations
- **delta** - Syntax-highlighted diffs with side-by-side view
- **fzf** - Fuzzy finder for files, history, and more
- **eza** - Modern `ls` with icons and git integration
- **bat** - `cat` with syntax highlighting

### Neovim (LazyVim)
- **GitHub Copilot** - AI pair programming
- **Harpoon** - Quick file navigation (`<leader>ha` to mark, `<leader>1-4` to jump)
- **LazyGit integration** - Press `<leader>gg` for git UI
- **Telescope** - Fuzzy finder with preview
- **LSP** - Language servers via Mason
- **Custom snippets** - For Python, Lua, Markdown

### Tmux
- **Prefix**: `Ctrl-a` (not `Ctrl-b`)
- **Vim integration** - Seamless pane navigation with `Ctrl-hjkl`
- **Session management** - Fuzzy session switcher (`prefix + s`)
- **Popups**: `prefix + g` (lazygit), `prefix + T` (scratch terminal), `prefix + P` (shell)
- **Plugins**: resurrect/continuum (session persistence), yank, open, copycat

### Zsh
- **Custom functions**: `mkcd`, `extract`, `gcp`, `dev`, `commit`
- **Git aliases**: `git st`, `git amend`, `git undo`, `git lg`
- **Starship prompt** - Beautiful Catppuccin theme with git metrics
- **Auto-suggestions** - Command completion as you type
- **Syntax highlighting** - Via chroma/colorize plugin

## Troubleshooting

### Neovim: Python provider not found
```bash
cd ~/.dotfiles
source .venv/bin/activate
pip install --upgrade pynvim
```

### Tmux: Plugins not loading
```bash
# Install TPM plugins
prefix + I

# Reload tmux config
prefix + r
```

### Zsh: Slow startup
```bash
# Profile zsh startup
zsh -i -c exit

# Check antidote bundle time
time antidote bundle
```

### Delta: Not showing side-by-side
```bash
# Check terminal width (needs ≥120 chars)
tmux display-message -p '#{pane_width}x#{pane_height}'

# Verify git pager config
git config core.pager
```
