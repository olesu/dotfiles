Trigger this skill when the user mentions: scope plugins, plugin scoping, move plugin to project, disable plugin globally, enabledPlugins, plugin showing up everywhere, MCP plugin in wrong project, disabledMcpjsonServers not working.

Scope a Claude Code plugin so it only appears in the projects that need it, instead of globally.

## The problem

`enabledPlugins` in `~/.claude/settings.json` activates a plugin in every project. Plugins typically provide MCP tools (e.g. the `swift-lsp` plugin provides Xcode MCP tools). Those tools then show up in every conversation, even in unrelated projects.

**`disabledMcpjsonServers` does not help here.** That key only suppresses servers configured via `mcp.json` files — it has no effect on MCP servers provided by plugins.

## The fix

1. Remove the plugin from global settings (`~/.dotfiles/claude/settings.json`):

```json
// Remove this block:
"enabledPlugins": {
  "some-plugin@some-marketplace": true
}
```

2. Add it to each project that actually needs it (`.claude/settings.json` in the project root):

```json
{
  "enabledPlugins": {
    "some-plugin@some-marketplace": true
  }
}
```

Create the file if it doesn't exist.

## Example: swift-lsp plugin

The `swift-lsp@claude-plugins-official` plugin provides Xcode MCP tools. It belongs only in Swift/Xcode projects, not in a dotfiles repo or a Python project.

Remove from `~/.dotfiles/claude/settings.json`, add to each Swift project's `.claude/settings.json`.

## Notes

- Project-level `settings.json` lives at `<project-root>/.claude/settings.json`.
- `enabledPlugins` can coexist with other project settings like `permissions`.
- After moving the plugin, commit and push in `~/.dotfiles` if the global settings file is tracked there.
