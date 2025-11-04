# Aliases
cat() {
    if [[ -t 1 ]]; then
        command colorize_cat "$@"
    else
        command cat "$@"
    fi
}

alias less='cless'
