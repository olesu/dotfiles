#!/opt/homebrew/bin/bash

BREW=/opt/homebrew/bin/brew

echo "=== Janitor: $(date) ==="

printf '\n--- brew update ---\n'
$BREW update

printf '\n--- brew upgrade ---\n'
$BREW upgrade

printf '\n--- brew autoremove ---\n'
$BREW autoremove

printf '\n--- brew cleanup ---\n'
$BREW cleanup

printf '\n--- brew doctor ---\n'
$BREW doctor

printf '\n=== Done ===\n'
