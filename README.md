# Dotfiles

Personal workstation configuration with Neovim, Tmux, and Zsh.

## Prerequisites

- macOS with Homebrew
- Zsh
- Neovim (0.9+)
- Tmux
- Git

## Quick Start

1. Clone the repository:
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
   # Neovim
   rm -rf ~/.config/nvim
   ln -sf ~/.dotfiles/nvim ~/.config/nvim
   
   # Tmux
   ln -sf ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf
   ```

4. Configure Zsh. Add to your `~/.zshrc`:
   ```bash
   # Source Zsh configuration from dotfiles
   ZSH_CONFIG_DIR="${HOME}/.dotfiles/zsh"
   source "${ZSH_CONFIG_DIR}/zshrc.zsh"
   ```

5. Reload shell:
   ```bash
   exec zsh
   ```

## Configuration Details

### Neovim

- **Python provider**: Uses `~/.dotfiles/.venv/python` (must have pynvim installed)
- **Plugin manager**: LazyVim
- **Location**: `~/.config/nvim` → `~/.dotfiles/nvim`

See [nvim/README.md](./nvim/README.md) for more details.

### Tmux

- **Prefix**: `Ctrl-a` (remapped from `Ctrl-b`)
- **Theme**: Catppuccin Mocha
- **Plugins**: Managed via TPM (Tmux Plugin Manager)
- **Pane numbering**: Starts at 1 (not 0)
- **Location**: `~/.tmux.conf` → `~/.dotfiles/tmux/tmux.conf`

See [tmux/README.md](./tmux/README.md) for more details.

### Zsh

- **Configuration location**: `~/.dotfiles/zsh/`
- **Plugin manager**: Antidote (via Oh My Zsh)
- **Plugins**: See `zsh_plugins.txt`

Modular setup with separate files:
- `env.zsh` - Environment variables
- `plugins.zsh` - Plugin configuration
- `aliases.zsh` - Aliases
- `functions.zsh` - Custom functions

## Python Virtual Environment

The `.venv` in the dotfiles directory is used exclusively for Neovim's Python provider. It requires `pynvim`:

```bash
cd ~/.dotfiles
source .venv/bin/activate
pip install --upgrade pip pynvim
```

Project-specific virtual environments (`.venv` in project directories) are automatically detected by LSP servers and tools.
