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
DOCTOR_OUTPUT=$($BREW doctor 2>&1)
echo "$DOCTOR_OUTPUT"

if echo "$DOCTOR_OUTPUT" | grep -q "Warning:"; then
    osascript -e 'display notification "brew doctor found warnings — check ~/Library/Logs/com.olesu.janitor.log" with title "Janitor"'
fi

printf '\n=== Done ===\n'
