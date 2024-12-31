nvim() {
    if [ -n "$NVIM" ]; then
        command nvr --remote "$@"
        return
    fi

    command nvim "$@"
}
