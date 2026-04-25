# load antidote
zstyle ":antidote:bundle" file "${ZSH_CONFIG_DIR}/zsh_plugins.txt"
zstyle ":antidote:static" file "${ZDOTDIR:-$HOME}/.zsh_plugins.zsh"
source "$(brew --prefix)"/opt/antidote/share/antidote/antidote.zsh
antidote load

# ohmyzsh eza plugin
zstyle ':omz:plugins:eza' 'git-status' yes
zstyle ':omz:plugins:eza' 'icons' yes
zstyle ':omz:plugins:eza' 'hyperlink' yes

# ohmyzsh colorize plugins
export ZSH_COLORIZE_TOOL=chroma
export ZSH_COLORIZE_STYLE=tokyonight-night
export ZSH_COLORIZE_CHROMA_FORMATTER=terminal16m

# zoxide
eval "$(zoxide init zsh)"

# Vi mode
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -v
export KEYTIMEOUT=15
bindkey -M viins 'jk' vi-cmd-mode
bindkey -M vicmd 'vv' edit-command-line

function zle-keymap-select {
  if [[ $KEYMAP == vicmd ]]; then
    echo -ne '\e[1 q'  # block cursor
    STARSHIP_KEYMAP=vicmd
  else
    echo -ne '\e[5 q'  # beam cursor
    unset STARSHIP_KEYMAP
  fi
  zle reset-prompt
}
zle -N zle-keymap-select

function zle-line-init {
  echo -ne '\e[5 q'  # beam cursor on new line
}
zle -N zle-line-init
