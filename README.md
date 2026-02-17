# Dotfiles

Personal macOS workstation configuration for Neovim, Tmux, and Zsh.

## Prerequisites

Install required tools via Homebrew:

```bash
brew install git-delta jq yq zoxide lazygit
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
