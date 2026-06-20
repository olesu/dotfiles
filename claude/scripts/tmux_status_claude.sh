#!/usr/bin/env bash
# Catppuccin-style Claude Code status pill for tmux status-right.
# Pill disappears entirely when Claude isn't running.
# Called by tmux every status-interval seconds via #().

STATUS_FILE="/tmp/claude_tmux_status"

[ ! -f "$STATUS_FILE" ] && exit 0

file_mtime=$(stat -f %m "$STATUS_FILE" 2>/dev/null) || exit 0
age=$(( $(date +%s) - file_mtime ))
[ "$age" -gt 120 ] && exit 0

content=$(cat "$STATUS_FILE" 2>/dev/null)
[ -z "$content" ] && exit 0

ctx_pct=$(printf '%s' "$content" | cut -d'|' -f2)

# Context color: green → yellow → red
if [ "${ctx_pct:-0}" -lt 50 ]; then
  c_ctx="#a6e3a1"
elif [ "${ctx_pct:-0}" -lt 80 ]; then
  c_ctx="#f9e2af"
else
  c_ctx="#f38ba8"
fi

# Pull live values from the running Catppuccin tmux theme
icon_bg=$(tmux show-option -gqv "@thm_mauve"      2>/dev/null); icon_bg="${icon_bg:-#cba6f7}"
icon_fg=$(tmux show-option -gqv "@thm_crust"      2>/dev/null); icon_fg="${icon_fg:-#11111b}"
text_bg=$(tmux show-option -gqv "@thm_surface_0"  2>/dev/null); text_bg="${text_bg:-#313244}"
left_sep=$(tmux show-option -gqv "@catppuccin_status_left_separator"  2>/dev/null)
right_sep=$(tmux show-option -gqv "@catppuccin_status_right_separator" 2>/dev/null)

# Pill structure mirrors Catppuccin status_module.conf:
#   [fg=icon_bg,bg=default]{left_sep}   ← rounded left cap
#   [fg=icon_fg,bg=icon_bg] {model}     ← coloured icon section
#   [fg=c_ctx,bg=text_bg] ctx {ctx}     ← text section (ctx colour)
#   [fg=text_bg,bg=default]{right_sep}  ← rounded right cap
printf '#[fg=%s]#[bg=default]%s#[fg=%s,bg=%s]󰚩 #[fg=%s,bg=%s] %s%% #[fg=%s]#[bg=default]%s#[default]' \
  "$icon_bg" "$left_sep" \
  "$icon_fg" "$icon_bg" \
  "$c_ctx"   "$text_bg" "$ctx_pct" \
  "$text_bg" "$right_sep"
