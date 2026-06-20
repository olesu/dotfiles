#!/usr/bin/env bash
b=$'\033[1m'
c=$'\033[36m'
y=$'\033[33m'
d=$'\033[90m'
r=$'\033[0m'

printf '%s\n' "${b}${c}╭──────────────────────────────────────────────╮${r}"
printf '%s\n' "${b}${c}│           tmux custom bindings               │${r}"
printf '%s\n' "${b}${c}╰──────────────────────────────────────────────╯${r}"
printf '\n'

printf '%s\n' "${b}${y}C-Space Popups${r}  (no prefix — hit C-Space then key)"
printf '%s\n' "${d}──────────────────────────────────────────────${r}"
printf '%s\n' "  ${b}p${r}   Shell popup in current dir"
printf '%s\n' "  ${b}g${r}   Lazygit (90%)"
printf '%s\n' "  ${b}a${r}   Claude Code (90%)"
printf '%s\n' "  ${b}t${r}   Shell popup (80%)"
printf '%s\n' "  ${b}c${r}   This cheatsheet"
printf '\n'

printf '%s\n' "${b}${y}Prefix (C-a) Bindings${r}"
printf '%s\n' "${d}──────────────────────────────────────────────${r}"
printf '%s\n' "  ${b}r${r}   Reload tmux config"
printf '%s\n' "  ${b}]${r}   Paste from macOS clipboard (pbpaste)"
printf '%s\n' "  ${b}o${r}   Session switcher (sessionx)"
printf '\n'

printf '%s\n' "${b}${y}Copy Mode${r}  (C-a [  then vi keys)"
printf '%s\n' "${d}──────────────────────────────────────────────${r}"
printf '%s\n' "  ${b}A${r}   Yank selection → macOS clipboard + open Claude popup"
printf '\n'

printf '%s\n' "${d}Press q to close${r}"
