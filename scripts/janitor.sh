#!/opt/homebrew/bin/bash

BREW=/opt/homebrew/bin/brew
DOTFILES="$HOME/.dotfiles"

echo "=== Janitor: $(date) ==="

# Log the commit hash so the audit trail shows exactly which version ran.
# Abort if the script has been modified on disk outside of git (local tampering guard).
COMMIT=$(git -C "$DOTFILES" log -1 --format="%H" -- scripts/janitor.sh 2>/dev/null)
echo "janitor.sh @ ${COMMIT:-unknown}"

if ! git -C "$DOTFILES" diff --quiet HEAD -- scripts/janitor.sh 2>/dev/null; then
    echo "ERROR: scripts/janitor.sh has uncommitted local changes. Aborting."
    osascript -e 'display notification "Janitor aborted: scripts/janitor.sh has local modifications" with title "Janitor Security Check"'
    exit 1
fi

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
