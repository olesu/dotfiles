# Workstation Management

## Python virtual environment

```bash
python3 -mvenv .venv
source .venv/bin/activate
```

Install pynvim

```bash
pip install --upgrade pip pynvim
```

See [python.lua](./nvim/lua/python.lua) for more details.

## Setup Instructions

### Initial Setup

1. Clone this repository to `~/.dotfiles`:
   ```bash
   git clone <your-repo-url> ~/.dotfiles
   cd ~/.dotfiles
   ```

2. Set up Python virtual environment:
   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   pip install --upgrade pip pynvim
   ```

3. Configure your `~/.zshrc`:
   ```bash
   # Source Zsh configuration from dotfiles
   ZSH_CONFIG_DIR="${HOME}/.dotfiles/zsh"
   source "${ZSH_CONFIG_DIR}/zshrc.zsh"
   ```

4. Follow the setup instructions in each subdirectory:
   - [nvim/README.md](./nvim/README.md) - Neovim configuration
   - [tmux/README.md](./tmux/README.md) - Tmux configuration
