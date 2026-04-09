# Build Fix — Output Template

Use this format when presenting a build error diagnosis. Follow it exactly — showing the root cause before the fix ensures the developer understands why, not just what to change.

---

## Build Error Diagnosis

### Error Summary

| Field | Value |
|-------|-------|
| **Type** | {Dependency / Compilation / Environment / Docker / CI/CD / Lock File / Cache} |
| **Component** | {Package name, file, or pipeline step that's failing} |
| **Environment** | {Local / CI/CD / Docker / Both} |

### Error Output

```
{The key lines from the error log — not the full output unless it's short. Include the line that names the error and the line that names the file or package.}
```

### Root Cause Analysis

{2–3 sentences explaining WHY this is failing, not just what the error message says. Connect what changed to why the error appeared. Example: "React 18 dropped support for the `render` API used by `@testing-library/react` v12. The CI environment installs fresh dependencies each run, so it picked up the peer conflict that your local node_modules was masking from a previous install."}

### Proposed Fix

**File:** `path/to/file`

```diff
- {old line or block}
+ {new line or block}
```

**Why this works:** {One sentence connecting the fix to the root cause}

### Alternative Approaches

{Only include this section if there are meaningfully different approaches with real trade-offs. Omit if there's only one viable fix.}

| Approach | Trade-off |
|----------|-----------|
| {Option A} | {What you gain / lose} |
| {Option B} | {What you gain / lose} |

### Verification Steps

1. `{Exact command to run}` — {what success looks like}
2. {Additional verification if needed, e.g. re-trigger CI, rebuild Docker image}

---

**Stop here. Waiting for your approval before applying the fix.**

---

## Style Rules

- **Lead with root cause, not the fix.** A developer who understands why is more likely to catch similar issues in the future — and less likely to revert the fix by accident.
- **Show the diff, not prose.** Use `diff` code blocks for all proposed changes. It's unambiguous and copy-pasteable.
- **Be specific about scope.** Name the exact file and line. Never say "update the config" — say which config, which key, what value.
- **Flag side effects.** If regenerating a lock file, running `npm dedupe`, or upgrading a package might silently change other behavior, say so explicitly before the user approves.
- **One fix at a time.** Present the minimal fix for this error. If there are follow-on issues that will appear after this fix, note them in Verification Steps — don't pre-emptively fix them without a new round of approval.
- **Omit sections with nothing to say.** Don't include "Alternative Approaches" with a single option, or "Verification Steps" that just say "run the build again." Only include sections that add information.
