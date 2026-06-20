# Aliases
cat() {
    if [[ -t 1 ]]; then
        command bat "$@"
    else
        command cat "$@"
    fi
}

alias less='cless'

# Claude Code injects GITHUB_TOKEN into subprocesses; unset it so gh uses keyring credentials
alias gh='env -u GITHUB_TOKEN gh'
