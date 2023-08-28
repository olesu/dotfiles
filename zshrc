ANTIGEN_ZSH="$HOME/.antigen/antigen.zsh"

if ! [ -f "$ANTIGEN_ZSH" ]; then
    mkdir -p "$(basename "$ANTIGEN_ZSH")"
    curl -L git.io/antigen > "$ANTIGEN_ZSH"
    # or use git.io/antigen-nightly for the latest version
fi

source "$ANTIGEN_ZSH"

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle command-not-found

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

antigen bundle 'https://github.com/MohamedElashri/exa-zsh.git@main'

# Load the theme.
antigen theme robbyrussell

# Tell Antigen that you're done.
antigen apply
