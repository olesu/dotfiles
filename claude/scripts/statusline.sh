#!/usr/bin/env bash
# Claude Code status line: cwd (branch) | model | context
# Receives session JSON on stdin; outputs a single line to stdout.

set -u

input="$(cat)"

model=$(printf '%s' "$input" | jq -r '.model.display_name // .model.id // "?"')
cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // ""')
transcript=$(printf '%s' "$input" | jq -r '.transcript_path // ""')
exceeds_200k=$(printf '%s' "$input" | jq -r '.exceeds_200k_tokens // false')

# Working directory + git branch
dir_label="${cwd##*/}"
[ -z "$dir_label" ] && dir_label="~"
branch=""
if [ -n "$cwd" ] && [ -d "$cwd/.git" ] || git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -C "$cwd" symbolic-ref --short -q HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null || true)
fi
# Context usage from the most recent assistant usage block in the transcript.
ctx_tokens=0
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
  ctx_tokens=$(tail -r "$transcript" 2>/dev/null \
    | jq -r 'select(.message.usage != null) | .message.usage
             | ((.input_tokens // 0)
                + (.cache_read_input_tokens // 0)
                + (.cache_creation_input_tokens // 0))' \
    | awk 'NF { print; exit }')
  [ -z "$ctx_tokens" ] && ctx_tokens=0
fi

# Window: 200k normally, 1M when the "exceeds 200k" flag is set.
if [ "$exceeds_200k" = "true" ]; then
  ctx_window=1000000
else
  ctx_window=200000
fi

ctx_pct=$(awk -v t="$ctx_tokens" -v w="$ctx_window" 'BEGIN{ if (w<=0) print 0; else printf "%d", (t*100)/w }')
ctx_human=$(awk -v t="$ctx_tokens" 'BEGIN{
  if (t >= 1000000) printf "%.1fM", t/1000000;
  else if (t >= 1000) printf "%.1fk", t/1000;
  else printf "%d", t;
}')
win_human=$(awk -v w="$ctx_window" 'BEGIN{
  if (w >= 1000000) printf "%dM", w/1000000;
  else printf "%dk", w/1000;
}')

# ANSI colors (24-bit truecolor; falls back gracefully if unsupported).
esc=$'\033'
reset="${esc}[0m"
bold="${esc}[1m"
c_dir="${esc}[38;5;39m"      # bright blue
c_branch="${esc}[38;5;213m"  # pink/magenta
c_model="${esc}[38;5;141m"   # purple
c_sep="${esc}[38;5;240m"     # dim grey

# Context color shifts from green → yellow → red as usage rises.
if [ "$ctx_pct" -lt 50 ]; then
  c_ctx="${esc}[38;5;42m"   # green
elif [ "$ctx_pct" -lt 80 ]; then
  c_ctx="${esc}[38;5;214m"  # orange
else
  c_ctx="${esc}[38;5;203m"  # red
fi

# Compose loc with separate colors for dir and branch.
if [ -n "$branch" ]; then
  loc_colored="${c_dir}${bold}${dir_label}${reset} ${c_branch}(${branch})${reset}"
else
  loc_colored="${c_dir}${bold}${dir_label}${reset}"
fi

sep="${c_sep} | ${reset}"
ctx_segment="${c_ctx}ctx ${ctx_human}/${win_human} (${ctx_pct}%)${reset}"
model_segment="${c_model}${model}${reset}"

printf '%b%b%b%b%b\n' \
  "$loc_colored" "$sep" \
  "$model_segment" "$sep" \
  "$ctx_segment"

# Side-effect: persist state for the tmux status pill (read by tmux_status_claude.sh)
printf '%s|%d|%s|%s' "$model" "$ctx_pct" "$ctx_human" "$win_human" > /tmp/claude_tmux_status
