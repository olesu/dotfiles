# Tmux Setup

## Install Tmux

```bash
brew install tmux
```

Link config file

```bash
ln -s ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf
```

## Install Tmux Plugin Manager

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
### Install plugins

1. Start tmux
2. Press `prefix + I` (capital I, as in Install) to fetch the plugin.

## Set up powerline fonts

### Install powerline fonts

```bash
brew tap homebrew/cask-fonts
brew install --cask font-meslo-lg-nerd-font
```

### Set up terminal to use powerline fonts

1. Open iTerm2
2. Preferences > Profiles > Text
3. Change Font to MesloLGL Nerd Font