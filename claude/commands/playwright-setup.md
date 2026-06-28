Trigger this skill when the user mentions: playwright setup, add playwright, install playwright, playwright in swift, playwright in xcode, playwright e2e, add e2e tests, set up playwright.

Set up Playwright for end-to-end web testing in a native (Swift/Xcode or other non-JS) project.

Playwright has no Swift client — the Node.js runner is used regardless of the host project's language. Keep it isolated in a subfolder so it doesn't pollute the native build system.

## Step 1 — Create the e2e subfolder

```bash
mkdir e2e
```

Use `e2e/` unless the project already has a different convention for test directories.

## Step 2 — Initialise Playwright

```bash
cd e2e && npm init playwright@latest
```

Accept the defaults (TypeScript, `tests/` folder, GitHub Actions workflow optional). This creates:
- `package.json`
- `playwright.config.ts`
- `tests/example.spec.ts`
- `node_modules/` (gitignored below)

## Step 3 — Gitignore node_modules

Add to the project root `.gitignore` (create it if absent):

```
e2e/node_modules/
```

Do **not** gitignore `e2e/package.json`, `e2e/package-lock.json`, or `e2e/playwright.config.ts` — those must be committed.

## Step 4 — Write a test

Edit `e2e/tests/` to add a spec for the external site. Minimal example:

```typescript
import { test, expect } from '@playwright/test';

test('homepage loads', async ({ page }) => {
  await page.goto('https://example.com');
  await expect(page).toHaveTitle(/Example/);
});
```

## Step 5 — Run the tests

```bash
cd e2e && npx playwright test
```

To run with a visible browser (useful for debugging):

```bash
npx playwright test --headed
```

To open the interactive UI:

```bash
npx playwright test --ui
```

## Notes

- Browser binaries are downloaded by `npm init playwright@latest`. To install only specific browsers later: `npx playwright install chromium`.
- The `e2e/` folder is entirely self-contained — CI just needs Node.js installed alongside the native toolchain.
