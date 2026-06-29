# Dotfiles

Personal macOS workstation configuration for Neovim, Tmux, Zsh, and Claude Code.

## Setup

1. Clone the repository:

   ```bash
   git clone <your-repo-url> ~/.dotfiles
   cd ~/.dotfiles
   ```

2. Install Homebrew dependencies:

   ```bash
   brew bundle
   ```

3. Run the install script:

   ```bash
   bash install.sh
   ```

4. Add to `~/.zshrc`:

   ```bash
   export ZSH_CONFIG_DIR="${HOME}/.dotfiles/zsh"
   source "${ZSH_CONFIG_DIR}/zshrc.zsh"
   ```

5. Load launchd agents:

   ```bash
   launchctl load ~/Library/LaunchAgents/com.olesu.janitor.plist
   launchctl load ~/Library/LaunchAgents/com.olesu.update-claude-code.plist
   ```

6. Create Python venv for Neovim:

   ```bash
   python3 -m venv ~/.dotfiles/.venv
   source ~/.dotfiles/.venv/bin/activate
   pip install pynvim
   ```

7. Point iTerm2 at `~/.dotfiles/iterm2/` via *Settings → General → Preferences → Load preferences from a custom folder*.

## What's Inside

- **nvim/** — Neovim config (LazyVim) symlinked to `~/.config/nvim`
- **tmux/** — Tmux config symlinked to `~/.tmux.conf`
- **starship/** — Starship prompt config symlinked to `~/.config/starship.toml`
- **zsh/** — Zsh configuration with Antidote plugin manager
- **claude/** — Claude Code skills, settings, scripts, and CLAUDE.md
- **git/** — Git config symlinked to `~/.gitconfig`
- **lazygit/** — Lazygit config symlinked to `~/.config/lazygit/config.yml`
- **scripts/** — Shell scripts for launchd agents and Claude Code skills
- **bin/** — Personal wrappers symlinked into `~/.local/bin/`
- **launchd/** — macOS scheduled agents (janitor, Claude Code updater)
- **iterm2/** — iTerm2 preferences (loaded directly by iTerm2)
- **.venv/** — Python virtual environment for Neovim's pynvim provider
- **Brewfile** — Homebrew dependencies

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
zsh -i -c exit
```
