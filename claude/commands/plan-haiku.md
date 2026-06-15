Trigger this skill when the user mentions: plan-haiku, haiku plan, plan then haiku, plan then execute, sonnet plan haiku execute.

Implement a task using the Sonnet-plans-then-Haiku-executes workflow: a Sonnet planner reads the real source files and produces a Haiku-grade spec; Haiku then follows it mechanically with no judgment calls.

## When to use this pattern

Use when a task is (or could be) Haiku-safe:
- Purely additive changes (new properties/functions, not restructuring existing ones)
- Confined to 2–3 files
- No cross-layer architectural decisions needed
- The "what" is clear, only the "exactly where and how" needs deriving from the code

If the task clearly requires Sonnet-level judgment (cross-file refactors, architecture decisions, novel algorithms), say so and skip the skill.

## Step 1 — Identify the task

If the user passed an issue file path as argument (e.g. `/plan-haiku docs/issues/0031-foo.md`), read that file. Otherwise derive the task from the conversation context.

Identify:
- The exact change to make (new properties, new view components, new tests)
- The files likely involved (from the issue's "Files" section or your knowledge of the codebase)

## Step 2 — Spawn Sonnet planner

Spawn a Plan agent (subagent_type: "Plan") with a prompt that:

1. States the task clearly
2. Lists the files to read (issue file + all referenced source files + test files)
3. Asks the planner to produce a **Haiku-grade execution plan** with ALL of the following — if any are missing the plan is not ready:
   - Exact file paths for every change (2–3 files max)
   - Explicit **"DO NOT TOUCH"** list naming every other file in the area
   - Exact insertion point per change: "after line X" / "after property Y" / "before function Z"
   - Exact Swift code to insert — copy-paste ready, matching surrounding style, no placeholders
   - Exact test factory call signatures derived from reading the actual test file (never guessed)
   - No "or" choices — every decision made, one path only
   - A build step (`mcp__xcode__BuildProject`) after each logical group of changes
   - A test run after all tests are added

Run the planner in the foreground (not background) so you receive the plan before continuing.

## Step 3 — Review the plan

Present the plan to the user. Then evaluate it yourself against the Haiku-safe checklist:

- [ ] Every file change has an exact insertion point
- [ ] Explicit DO NOT TOUCH list present
- [ ] All code is copy-paste ready (no "add something like…")
- [ ] Test factory signatures read from actual test file, not guessed
- [ ] No remaining "or" choices
- [ ] Build steps included

If any item is unchecked, flag it and ask the user whether to refine the plan first or proceed anyway.

Ask the user: **"Plan looks good — proceed with Haiku?"** (or flag issues first). Do not launch Haiku without explicit confirmation.

## Step 4 — Spawn Haiku executor

Once confirmed, spawn a Haiku agent (`model: "haiku"`, `isolation: "worktree"`) with a prompt that:

1. States the file guard at the top: "You may ONLY touch these files: [list]. Do NOT read or modify any other file. Do NOT create new files."
2. Includes the complete plan as numbered steps with exact code blocks
3. Includes a build step after each logical group
4. Ends with: run all tests (`mcp__xcode__RunAllTests`), confirm they pass, commit, update issue frontmatter `status: open` → `status: done`, update `docs/issues/README.md`

Run Haiku in the background. Report when it completes.

## Step 5 — Verify

When Haiku completes, check:
- `git log --oneline -3` — commits look right
- `git diff HEAD~N HEAD --name-only` — only the expected files changed

Report the result. If unexpected files were touched, flag it immediately.

## Rules

- Never skip Step 3 (user review). The plan gate is the whole point of this skill.
- Never pass a plan with "or" choices to Haiku — resolve them first.
- If Haiku touches files outside the stated guard, report it as a failure even if tests pass.
- This skill is for implementation tasks only. For debugging or exploratory work, use Sonnet directly.
