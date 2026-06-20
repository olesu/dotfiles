Trigger this skill when the user mentions: fix gh auth, gh authentication broken, GITHUB_TOKEN conflict, fix-gh-auth.

Set up (or repair) the `gh` wrapper that prevents Claude Code's injected `GITHUB_TOKEN` from overriding 1Password credentials.

## Background

Claude Code injects a `GITHUB_TOKEN` env var into every Bash subprocess. When this token is stale or invalid, the `gh` CLI picks it up instead of the valid credential from the 1Password keychain, causing 401 errors. The fix is a wrapper script at `~/.local/bin/gh` (which comes before `/opt/homebrew/bin` in `$PATH`) that unsets `GITHUB_TOKEN` and re-injects fresh credentials via `op plugin run`.

## Steps

1. Verify the wrapper source exists:
   ```bash
   ls -la ~/.dotfiles/bin/gh
   ```
   If missing, create it:
   ```bash
   cat > ~/.dotfiles/bin/gh << 'EOF'
   #!/bin/sh
   exec env -u GITHUB_TOKEN op plugin run -- /opt/homebrew/bin/gh "$@"
   EOF
   chmod +x ~/.dotfiles/bin/gh
   ```

2. Verify the symlink exists:
   ```bash
   ls -la ~/.local/bin/gh
   ```
   If missing or pointing to the wrong target, recreate it:
   ```bash
   ln -sf ~/.dotfiles/bin/gh ~/.local/bin/gh
   ```

3. Confirm `~/.local/bin` appears before `/opt/homebrew/bin` in `$PATH`:
   ```bash
   echo $PATH | tr ':' '\n' | grep -n "local/bin\|homebrew/bin"
   ```
   If out of order, check `zsh/env.zsh` — `path+=~/.local/bin` should be present.

4. Smoke test:
   ```bash
   gh auth status
   ```
   Expect: `✓ Logged in to github.com account olesu` with no GITHUB_TOKEN failure.

## Rules

- Never edit `~/.config/op/plugins.sh` — it is managed by the 1Password CLI.
- The wrapper hardcodes `/opt/homebrew/bin/gh` (Apple Silicon path). On Intel Macs use `/usr/local/bin/gh`.
- If `op` is not in PATH, the wrapper will fail — ensure the 1Password CLI is installed (`brew install 1password-cli`).
