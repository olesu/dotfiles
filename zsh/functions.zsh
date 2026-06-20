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

# Verify antidote plugin SHAs against zsh_plugins.lock
zsh_verify_plugins() {
  local base="$HOME/Library/Caches/antidote"
  local lockfile="${ZSH_CONFIG_DIR}/zsh_plugins.lock"
  local ok=1
  while IFS=' ' read -r repo sha rest; do
    [[ "$repo" == \#* || -z "$repo" ]] && continue
    local encoded="${repo/\//-SLASH-}"
    local dir="$base/https-COLON--SLASH--SLASH-github.com-SLASH-${encoded}"
    local actual
    actual=$(git -C "$dir" log -1 --format="%H" 2>/dev/null)
    if [[ "$actual" != "$sha" ]]; then
      echo "MISMATCH: $repo"
      echo "  expected: $sha"
      echo "  installed: ${actual:-not found}"
      ok=0
    fi
  done < "$lockfile"
  [[ $ok -eq 1 ]] && echo "All plugins match lockfile ✓"
}

# Conventional commit helper
commit() {
    local types=("feat" "fix" "docs" "style" "refactor" "perf" "test" "chore" "ci" "build")
    
    echo "Select commit type:"
    select type in "${types[@]}"; do
        if [ -n "$type" ]; then
            break
        fi
    done
    
    echo -n "Scope (optional, press enter to skip): "
    read scope
    
    echo -n "Commit message: "
    read message
    
    if [ -n "$scope" ]; then
        git commit -m "${type}(${scope}): ${message}"
    else
        git commit -m "${type}: ${message}"
    fi
}
