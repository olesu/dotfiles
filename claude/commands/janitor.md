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

After Homebrew, check whether the three pinned supply chain dependencies have upstream updates.

### TPM (tmux plugin manager)

```bash
git -C ~/.tmux/plugins/tpm fetch origin
```

- Pinned SHA: read the 40-char hex from the `git checkout` line in `~/.dotfiles/tmux/tmux.conf`
- Latest upstream: `git -C ~/.tmux/plugins/tpm rev-parse origin/master`
- If they differ, show new commits: `git -C ~/.tmux/plugins/tpm log --oneline <pinned>..origin/master`

### lazy.nvim

```bash
git -C ~/.local/share/nvim/lazy/lazy.nvim fetch --tags origin
```

- Pinned SHA: read `pinned_lazy_sha` from `~/.dotfiles/nvim/lua/config/lazy.lua`
- Latest upstream: `git -C ~/.local/share/nvim/lazy/lazy.nvim tag --sort=-version:refname | grep -v stable | head -1` to find the newest version tag, then `git rev-parse <tag>`
- If the tag's SHA differs from the pin, show new commits: `git -C ~/.local/share/nvim/lazy/lazy.nvim log --oneline <pinned>..<latest-tag>`
- If updating: replace `pinned_lazy_sha` with the new tag's SHA, and note the version tag in the commit message

### Antidote zsh plugins

For each `owner/repo sha` line in `~/.dotfiles/zsh/zsh_plugins.lock`:

1. Encode the cache path: replace `/` with `-SLASH-`, prepend `https-COLON--SLASH--SLASH-github.com-SLASH-`
   - e.g. `zsh-users/zsh-completions` → `~/Library/Caches/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-zsh-users-SLASH-zsh-completions`
2. `git -C <cache-dir> fetch origin`
3. Compare locked SHA vs `git -C <cache-dir> rev-parse origin/HEAD`
4. If they differ, show new commits: `git -C <cache-dir> log --oneline <locked>..origin/HEAD`

### Reporting and updating

- If nothing is outdated: report "All supply chain pins are current."
- If updates exist: list each with how many new commits and a one-line summary of the most recent.
- Ask the user whether to update all, pick individually, or skip.

If updating:
- **TPM**: replace the SHA in the `git checkout` line in `~/.dotfiles/tmux/tmux.conf`
- **lazy.nvim**: replace the value of `pinned_lazy_sha` in `~/.dotfiles/nvim/lua/config/lazy.lua`
- **Antidote plugins**: run `antidote bundle` to pull the new versions, then update each SHA line in `~/.dotfiles/zsh/zsh_plugins.lock` to `origin/HEAD` of that repo
- Commit all changed files: `chore: bump supply chain pins`

## Rules

- Run Homebrew steps sequentially — each depends on the previous.
- If a Homebrew step fails, report the error and stop rather than continuing.
- If `brew doctor` says "Your system is ready to brew." treat it as clean.
- Do not run `brew upgrade --greedy` unless the user explicitly asks.
- Never update a supply chain pin without showing the changelog and getting confirmation first.
