LESSOPEN="|$(brew --prefix)/lesspipe.sh %s"
export LESSOPEN

FZF_BASE="$(brew --prefix)/opt/fzf"
export FZF_BASE

export FZF_CTRL_T_COMMAND="fd --type f | cless"

# ohmyzsh python plugin
export PYTHON_AUTO_VRUN=true
export PYTHON_VENV_NAME=venv

