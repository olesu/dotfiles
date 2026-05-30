Trigger this skill when the user mentions: janitor, maintenance, brew update, brew upgrade, system cleanup, run janitor.

Run system maintenance tasks and report the results.

## Homebrew

Run these in order, stopping if any step fails:

1. `brew update` — fetch latest formulae and cask definitions
2. `brew upgrade` — upgrade all outdated formulae and casks
3. `brew autoremove` — remove unused dependencies
4. `brew cleanup` — delete old versions and stale downloads
5. `brew doctor` — check for problems; surface any warnings or errors to the user

After all steps, print a short summary: what was upgraded (parse `brew upgrade` output), anything removed, and whether `brew doctor` came back clean.

## Supply chain pin check

After Homebrew, run:

```bash
~/.dotfiles/scripts/supply_chain_check.sh
```

Each output line has the format:
```
<name> <pinned-sha> up-to-date
<name> <pinned-sha> outdated <upstream-sha> <new-commit-count>
```

- If all lines say `up-to-date`: report "All supply chain pins are current."
- If any say `outdated`: for each, show the commit count and fetch the most recent commit message:
  - TPM: `git -C ~/.tmux/plugins/tpm log -1 --format="%s" origin/master`
  - lazy.nvim: `git -C ~/.local/share/nvim/lazy/lazy.nvim log -1 --format="%s" <upstream-sha>`
  - Antidote plugins: `git -C ~/Library/Caches/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-<owner>-SLASH-<repo> log -1 --format="%s" origin/HEAD`
    (encode the repo path by replacing `/` with `-SLASH-`)

Ask the user whether to update all, pick individually, or skip.

### Applying updates

**TPM** — replace the 40-char SHA in the `git checkout` line in `~/.dotfiles/tmux/tmux.conf`.

**lazy.nvim** — replace the value of `pinned_lazy_sha` in `~/.dotfiles/nvim/lua/config/lazy.lua`. Note the version tag in the commit message.

**Antidote plugins** — for each outdated plugin, `git -C <cache-dir> pull --ff-only`, then update its SHA line in `~/.dotfiles/zsh/zsh_plugins.lock`. Note: this updates the cache on disk but `~/.zsh_plugins.zsh` (the compiled bundle) won't reflect the change until the user runs `antidote bundle` in a real shell — remind them.

Commit all changed files: `chore: bump supply chain pins`

## Rules

- Run Homebrew steps sequentially — each depends on the previous.
- If a Homebrew step fails, report the error and stop rather than continuing.
- If `brew doctor` says "Your system is ready to brew." treat it as clean.
- Do not run `brew upgrade --greedy` unless the user explicitly asks.
- Never update a supply chain pin without showing the changelog and getting confirmation first.
