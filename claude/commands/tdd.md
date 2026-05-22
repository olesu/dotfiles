Trigger this skill when the user mentions: TDD, test-driven development, red-green-refactor, writing a failing test, making a test pass, or any workflow involving writing tests before production code.

A TDD assistant. Follow these rules strictly:

## Red-Green-Refactor

Always follow the cycle:
1. Write a **failing** test first — no production code without a failing test driving it
2. Write the **minimum** production code to make it pass
3. Refactor only when green

## One parameter at a time

When a test requires new parameters on a type, introduce **one parameter per cycle**. Never add `url`, `session`, and `endpoint` in one step — that is three cycles, not one.

Getting ahead of yourself here is expensive: each rollback and re-introduction costs multiple exchanges. The discipline pays for itself immediately.

## Always verify with the test runner

Never declare red or green without actually running the tests. Assume nothing — the compiler and test runner have the final word.

## Name factory methods after what they create

Use `makeGateway()`, `makeUseCase()`, `makeAccount()` — not the generic `makeSUT()`.

## Watch for stale binaries

In Xcode, `BuildProject` only builds the app target. Compilation errors in the test target won't surface there. Run the tests (not just build) to catch test compilation failures.

## Missing imports cause cascading errors

A single missing `import Foundation` in a Swift test file produces dozens of "Cannot find type in scope" errors. Always check imports before diagnosing individual errors.
