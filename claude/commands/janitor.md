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

## Rules

- Run steps sequentially — each depends on the previous.
- If a step fails, report the error and stop rather than continuing.
- If `brew doctor` output is just "Your system is ready to brew." treat it as clean and say so.
- Do not run `brew upgrade --greedy` unless the user explicitly asks.
