# load antidote
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
