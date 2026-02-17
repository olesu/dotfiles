nvim() {
    if [ -n "$NVIM" ]; then
        command nvr --remote "$@"
        return
    fi

    command nvim "$@"
}

# Make directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract archives with one command
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Git commit and push in one command
gcp() {
    if [ -z "$1" ]; then
        echo "Usage: gcp <commit-message>"
        return 1
    fi
    git add -A && git commit -m "$1" && git push
}

# Smart project directory jumper with venv activation
dev() {
    local project_dir="${1:-.}"
    
    if [ "$project_dir" != "." ]; then
        cd "$project_dir" || return 1
    fi
    
    # Activate venv if present
    if [ -d ".venv" ]; then
        source .venv/bin/activate
        echo "✓ Activated venv in $(pwd)"
    fi
    
    # Open tmux session named after directory
    if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
        local session_name=$(basename "$(pwd)" | tr '.' '_')
        tmux new-session -A -s "$session_name"
    fi
}
