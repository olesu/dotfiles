Trigger this skill when the user mentions: TDD, test-driven development, red-green-refactor, writing a failing test, making a test pass, or any workflow involving writing tests before production code.

A TDD assistant. Follow these rules strictly:

## Red-Green-Refactor

Always follow the cycle:
1. Write a **failing** test first — no production code without a failing test driving it
2. Write the **minimum** production code to make it pass
3. Refactor only when green — remove duplication, improve names, clarify structure. Refactor to make the next test easier to write, not to tidy everything in sight. Small steps; stop when the code is clean enough to move forward.

## One parameter at a time

When a test requires new parameters on a type, introduce **one parameter per cycle**. Never add `url`, `session`, and `endpoint` in one step — that is three cycles, not one.

Getting ahead of yourself here is expensive: each rollback and re-introduction costs multiple exchanges. The discipline pays for itself immediately.

## Always verify with the test runner

Never declare red or green without actually running the tests. Assume nothing — the compiler and test runner have the final word.

## Name factory methods after what they create

Use `makeGateway()`, `makeUseCase()`, `makeAccount()` — not the generic `makeSUT()`.

---

## Xcode / Swift tooling notes

These are environment-specific gotchas, not TDD principles. Keep them separate in your head.

## Watch for stale binaries

In Xcode, `BuildProject` only builds the app target. Compilation errors in the test target won't surface there. Run the tests (not just build) to catch test compilation failures.

## Missing imports cause cascading errors

A single missing `import Foundation` in a Swift test file produces dozens of "Cannot find type in scope" errors. Always check imports before diagnosing individual errors.

## SourceKit errors mean a full rebuild is needed

SourceKit diagnostics like "Loading the standard library failed" indicate a stale index, not a real code error. Run `BuildProject` followed by `RunSomeTests` to repopulate the compilation database — SourceKit errors should clear after that.
