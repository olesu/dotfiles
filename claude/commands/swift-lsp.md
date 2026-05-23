Trigger this skill when the user mentions: swift LSP, sourcekit-lsp, sourcekit, xcode-build-server, LSP setup for Swift, Swift code intelligence, swift language server.

Set up sourcekit-lsp for a Swift Xcode project so the LSP tool and editors (e.g. LazyVim) get accurate code intelligence.

## Step 1 — check xcode-build-server

```
which xcode-build-server
```

If not found:
```
brew install xcode-build-server
```

## Step 2 — detect scheme and project

Look for a `.xcodeproj` in the current directory and check `CLAUDE.md` for the scheme name. If there is exactly one `.xcodeproj`, use it. If the scheme is not in `CLAUDE.md`, it usually matches the project name.

```
ls *.xcodeproj
```

## Step 3 — generate buildServer.json

```
xcode-build-server config -scheme <Scheme> -project <Project>.xcodeproj
```

This creates `buildServer.json` at the project root. sourcekit-lsp reads this to query Xcode's build system for real compiler flags, SDK paths, and module search paths — eliminating false "unknown type" errors.

## Step 4 — verify

Check the generated file:
```
cat buildServer.json
```

It should contain `workspace`, `build_root`, and `scheme` fields. The `build_root` path points into `~/Library/Developer/Xcode/DerivedData/`.

## Notes

- **Do not commit `buildServer.json`** — it contains absolute paths specific to this machine. Add it to `.gitignore` if the project has a remote.
- **Regenerate only if** the scheme name or project file path changes. Routine builds do not require regeneration.
- **Build the project at least once** in Xcode (Cmd+B) before or after generating `buildServer.json`, so DerivedData is populated. sourcekit-lsp needs build artifacts to load the standard library.
- If LSP shows "Loading the standard library failed", build the project and restart the language server (`:lsp restart` in LazyVim).

## LSP tool in Claude Code

Once sourcekit-lsp is running, the `LSP` tool is available in Claude Code for:
- `hover` — type info and docs for any symbol
- `goToDefinition` / `goToImplementation` — navigate to source
- `findReferences` — find all usages across the project
- `documentSymbol` — list all symbols in a file
- `workspaceSymbol` — search symbols across the whole project
- `incomingCalls` / `outgoingCalls` — call hierarchy
