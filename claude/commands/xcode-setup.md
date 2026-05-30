Trigger this skill when the user mentions: xcode setup, xcode mcp, xcode mcp not loading, verify xcode mcp, set up xcode project, new xcode project setup, swift project setup.

Set up and verify the Xcode MCP and Swift LSP for a new Xcode project.

## Step 1 — Register Xcode MCP at project scope

Check whether `.mcp.json` exists in the project root with the xcode server. If not, add it:

```
claude mcp add xcode xcrun mcpbridge -s project
```

This writes to `.mcp.json` so the MCP only loads when working inside this repo.

## Step 2 — Verify MCP tools load

Use ToolSearch to check for `mcp__xcode__*` tools:

```
ToolSearch: mcp__xcode
```

If tools appear, MCP is working — skip to Step 4.

If tools do not appear, go to Step 3.

## Step 3 — Diagnose MCP connection failure

Work through these in order:

**Is Xcode running?**
```
pgrep -x Xcode
```
If not, open Xcode and retry Step 2.

**Is Xcode's Claude integration enabled?**
```
defaults read com.apple.dt.Xcode IDEChatIsBuiltInClaudeEnabled
```
If this returns `0`, go to Xcode → Settings → [AI/Coding tab] and enable Claude. Then restart Xcode and retry Step 2.

**Are there pending agent approvals in Xcode?**
Open Xcode and look for any "Allow agent?" prompts. Approve them, then start a new Claude Code session and retry Step 2.

## Step 4 — Set up Swift LSP

Run `/swift-lsp` to configure sourcekit-lsp for accurate code intelligence.
