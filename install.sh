#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/.dotfiles"

# ---------------------------------------------------------------------------
# Data: symlink pairs (source relative to $DOTFILES → absolute destination)
# ---------------------------------------------------------------------------

LINKS=(
  # Shell & prompt
  "tmux/tmux.conf                       $HOME/.tmux.conf"
  "starship/starship.toml               $HOME/.config/starship.toml"
  "gitmux/gitmux.conf                   $HOME/.gitmux.conf"
  "git/gitconfig                        $HOME/.gitconfig"
  "lazygit/config.yml                   $HOME/.config/lazygit/config.yml"

  # Neovim (directory — too many nested files to enumerate)
  "nvim                                  $HOME/.config/nvim"

  # Claude Code — config
  "claude/settings.json                 $HOME/.claude/settings.json"
  "claude/CLAUDE.md                     $HOME/.claude/CLAUDE.md"

  # Claude Code — scripts
  "claude/scripts/statusline.sh         $HOME/.claude/scripts/statusline.sh"
  "claude/scripts/tmux_status_claude.sh $HOME/.claude/scripts/tmux_status_claude.sh"
  "claude/scripts/lib.sh                $HOME/.claude/scripts/lib.sh"
  "claude/scripts/gh-repo-name.sh       $HOME/.claude/scripts/gh-repo-name.sh"
  "claude/scripts/gh-issue-list.sh      $HOME/.claude/scripts/gh-issue-list.sh"
  "claude/scripts/gh-issue-view.sh      $HOME/.claude/scripts/gh-issue-view.sh"

  # Claude Code — skills
  "claude/commands/extract-to-script.md   $HOME/.claude/commands/extract-to-script.md"
  "claude/commands/import-claude-config.md $HOME/.claude/commands/import-claude-config.md"
  "claude/commands/janitor.md             $HOME/.claude/commands/janitor.md"
  "claude/commands/kickoff.md             $HOME/.claude/commands/kickoff.md"
  "claude/commands/list-issues.md         $HOME/.claude/commands/list-issues.md"
  "claude/commands/playwright-setup.md    $HOME/.claude/commands/playwright-setup.md"
  "claude/commands/scope-plugins.md       $HOME/.claude/commands/scope-plugins.md"
  "claude/commands/ship.md                $HOME/.claude/commands/ship.md"
  "claude/commands/skill-authoring.md     $HOME/.claude/commands/skill-authoring.md"
  "claude/commands/swift-lsp.md           $HOME/.claude/commands/swift-lsp.md"
  "claude/commands/swift-tech-lead.md     $HOME/.claude/commands/swift-tech-lead.md"
  "claude/commands/tdd.md                 $HOME/.claude/commands/tdd.md"
  "claude/commands/view-issue.md          $HOME/.claude/commands/view-issue.md"
  "claude/commands/xcode-setup.md         $HOME/.claude/commands/xcode-setup.md"

  # Claude Code — agents
  "claude/agents/swift-code-monkey.md  $HOME/.claude/agents/swift-code-monkey.md"

  # Bin wrappers
  "bin/gh                               $HOME/.local/bin/gh"
)

LAUNCHD_PLISTS=(
  "com.olesu.janitor.plist"
  "com.olesu.update-claude-code.plist"
)

# ---------------------------------------------------------------------------
# Functions
# ---------------------------------------------------------------------------

link() {
  local src="$DOTFILES/$1" dst="$2"
  # If a directory symlink exists at the destination, remove it first
  # so we don't create file symlinks inside a symlinked directory
  if [[ -L "$dst" && -d "$dst" ]]; then
    rm "$dst"
  fi
  mkdir -p "$(dirname "$dst")"
  ln -sfn "$src" "$dst"
  echo "  $dst"
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

# Remove legacy directory symlinks that would cause file symlinks to be
# written back into the dotfiles repo itself.
for dir in "$HOME/.claude/commands" "$HOME/.claude/agents"; do
  if [[ -L "$dir" ]]; then
    echo "Removing directory symlink: $dir"
    rm "$dir"
  fi
done

echo "Creating symlinks..."
for entry in "${LINKS[@]}"; do
  read -r rel dst <<< "$entry"
  link "$rel" "$dst"
done

echo ""
echo "Creating launchd symlinks..."
for plist in "${LAUNCHD_PLISTS[@]}"; do
  link "launchd/$plist" "$HOME/Library/LaunchAgents/$plist"
done

echo ""
echo "Done. Manual steps remaining:"
echo "  1. Add to ~/.zshrc:"
echo "       export ZSH_CONFIG_DIR=\"\${HOME}/.dotfiles/zsh\""
echo "       source \"\${ZSH_CONFIG_DIR}/zshrc.zsh\""
echo "  2. Load launchd agents:"
for plist in "${LAUNCHD_PLISTS[@]}"; do
  echo "       launchctl load ~/Library/LaunchAgents/$plist"
done
echo "  3. Point iTerm2 at ~/.dotfiles/iterm2/ via Settings → General → Preferences"
echo "  4. Create Python venv for Neovim:"
echo "       python3 -m venv ~/.dotfiles/.venv && source ~/.dotfiles/.venv/bin/activate && pip install pynvim"
