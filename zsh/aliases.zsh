# Aliases
cat() {
    if [[ -t 1 ]]; then
        command bat "$@"
    else
        command cat "$@"
    fi
}

alias less='cless'
