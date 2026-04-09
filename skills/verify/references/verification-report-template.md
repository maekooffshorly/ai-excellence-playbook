# Verify — Output Template

Use this format when presenting a verification report. Lead with the overall verdict — the developer needs to know immediately whether the change is ready before reading the details.

---

## Verification Report: {Feature / Ticket / Brief Description}

### Verdict

**{✅ Ready | ✅ Ready with notes | ❌ Not Ready}**

{1–2 sentences explaining the verdict. If not ready, name the specific blocking issue(s).}

---

### Checklist Results

| Check | Status | Notes |
|-------|--------|-------|
| Tests | ✅ Pass / ❌ Fail / ⚠️ Warning | {Details — test count, what failed, what's missing} |
| Lint | ✅ Pass / ❌ Fail / ⚠️ Warning | {Details — errors found or clean} |
| Build | ✅ Pass / ❌ Fail / ⚠️ Warning | {Details — compilation errors, warnings introduced} |
| Acceptance Criteria | ✅ Pass / ❌ Fail / ⚠️ Warning | {How many criteria met vs total} |
| Documentation | ✅ Pass / ❌ Fail / ⚠️ Warning | {Gaps found or complete} |

*✅ Pass = check confirmed clear | ❌ Fail = blocking issue found | ⚠️ Warning = non-blocking observation*

---

### Acceptance Criteria

{Only include this section if a ticket was referenced or criteria were provided. Omit if none.}

| Criterion | Status | Notes |
|-----------|--------|-------|
| {Criterion from ticket} | ✅ Met / ❌ Not Met / ⚠️ Partial | {How it was verified} |

---

### Issues Found

{Only include this section if any check failed or produced a warning. Omit if all checks passed cleanly.}

#### Blockers *(must fix before PR)*

- **{Check category} — [filename:line](path#Lline)**: {What failed and why}
  - Suggested fix: use `build-fix` / `test-writer` / `docs` skill, or {specific action}

#### Observations *(non-blocking)*

- {Minor note that doesn't block the PR — style issue, a gap that's acceptable to track as follow-up, etc.}

---

### Commands Run

{Only include if commands were actually executed in the environment.}

```
{Command} → {Result summary}
```

---

## Style Rules

- **Verdict first, always.** The developer should see pass/fail in the first two lines without scrolling.
- **Be specific about failures.** "Tests fail" is not actionable. "3 tests fail in `auth_service.test.ts` — all related to the new token expiry logic" is.
- **Distinguish blockers from observations.** Only items that must be resolved before merge belong under Blockers. Everything else is an Observation.
- **Don't fix, point.** For each blocker, name which skill handles it — don't attempt the fix inline.
- **Note when checks are inferred vs run.** If you couldn't execute a command and assessed the result by reading code, say so: "(inferred — run `npm test` to confirm)". Don't present an inferred result as a confirmed pass.
- **Omit empty sections.** If all checks pass, omit "Issues Found" entirely. If no ticket was provided, omit "Acceptance Criteria". Only show what has content.
