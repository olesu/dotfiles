LESSOPEN="|$(brew --prefix)/lesspipe.sh %s"
export LESSOPEN

FZF_BASE="$(brew --prefix)/opt/fzf"
export FZF_BASE

export FZF_CTRL_T_COMMAND="fd --type f | cless"

# ohmyzsh python plugin
export PYTHON_AUTO_VRUN=true
export PYTHON_VENV_NAME=venv

source "${HOME}/.config/op/plugins.sh"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES

path+='/Applications/PyCharm CE.app/Contents/MacOS'
path+=~/.local/bin
