alias g=git
alias gst='g status'
alias ga='g add'
alias gaa='ga -A'
alias gcmsg='g commit -m'

. /usr/share/bash-completion/completions/git
__git_complete g __git_main
