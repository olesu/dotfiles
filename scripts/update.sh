#!/opt/homebrew/bin/bash

BREW=/opt/homebrew/bin/brew
RBENV=/opt/homebrew/bin/rbenv
DOTFILES="$HOME/.dotfiles"

echo "=== Update: $(date) ==="

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
    echo "Warning: brew doctor found issues. Please review them above."
fi

printf '\n--- rbenv ruby version check ---\n'
if [ -x "$RBENV" ]; then
    CURRENT_RUBY=$($RBENV global)
    MAJOR_MINOR=$(echo "$CURRENT_RUBY" | cut -d. -f1,2)
    LATEST_RUBY=$($RBENV install -l 2>/dev/null | grep -E "^\s*${MAJOR_MINOR//./\\.}\.[0-9]+$" | tail -1 | xargs)

    if [ -n "$LATEST_RUBY" ] && [ "$LATEST_RUBY" != "$CURRENT_RUBY" ]; then
        echo "Newer Ruby available: $CURRENT_RUBY -> $LATEST_RUBY. Installing..."
        if $RBENV install "$LATEST_RUBY" && $RBENV global "$LATEST_RUBY"; then
            echo "Ruby upgraded: $CURRENT_RUBY -> $LATEST_RUBY"
        else
            echo "ERROR: failed to upgrade Ruby $CURRENT_RUBY -> $LATEST_RUBY"
        fi
    else
        echo "Ruby $CURRENT_RUBY is up to date."
    fi
else
    echo "rbenv not found at $RBENV, skipping."
fi

printf '\n=== Done ===\n'
