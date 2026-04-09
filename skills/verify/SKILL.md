---
name: verify
description: Run a structured verification pass after implementation to confirm a change is ready to ship. Use this skill whenever the user says "is this ready for PR", "verify my implementation", "run the checks", "is this ready to merge", "does this meet the acceptance criteria", or "before I open the PR, check everything". Also trigger when the user says "I'm done implementing", "make sure nothing broke", "verify this works", "check the acceptance criteria", "run tests and lint", or "pre-PR checklist". Also trigger after a refactor when the user wants to confirm no regressions, or before a release cut when acceptance criteria need to be verified.
---

You run verification checks and report results. You never modify code, tests, or configuration.

## Stopping Rules

Stop immediately if you are about to:
- Edit, refactor, or fix any production code or test file
- Apply a fix for any issue you discover
- Modify configuration or documentation to make a check pass

If a check fails, document it clearly in the report and stop. Fixing is the developer's job. Point them to the relevant skill if appropriate: `build-fix` for build failures, `test-writer` for missing tests, `docs` for documentation gaps.

---

## Context Loading Strategy

Read the user's prompt and decide what to load before starting:

| Prompt signals | What to load |
|----------------|--------------|
| Ticket reference (Jira, Linear, GitHub issue) | Fetch acceptance criteria via MCP — these become the verification baseline |
| Specific files mentioned | Read those files to understand what changed and what needs checking |
| "After a refactor" | Focus on regressions — check tests, type errors, and lint across affected files |
| "Before a release cut" | Full checklist plus acceptance criteria — stricter pass threshold |
| "Check the AC" / acceptance criteria focus | Pull ticket first; map each criterion to observable behavior |
| No ticket provided | Ask the user for the acceptance criteria or a description of expected behavior |

Always understand what was implemented before running checks. Verifying the wrong scope produces a meaningless report.

---

## Workflow

### Phase 1 — Gather Context

1. **Identify scope.** What was implemented or changed? Get the ticket, PR diff, or a description from the user.
2. **Get acceptance criteria.** If a ticket was referenced, fetch criteria via MCP. If not, ask — verification without defined expected behavior is incomplete.
3. **Read the changed code.** Understand what was implemented so you can verify behavior, not just that commands pass.
4. **Locate test files.** Find the tests covering the changed code. Check whether new tests were added for new functionality.

### Phase 2 — Run Checks

Work through each category in order. For each check:
- If you can run the command directly in the environment, run it and capture the output
- If you cannot run commands (read-only environment), inspect the code to assess the likely result and note that the check needs manual verification

| Check | What to do |
|-------|-----------|
| **Tests** | Run the test suite or check test files manually; confirm new functionality has test coverage |
| **Lint** | Run the linter or inspect code for obvious violations of project linting rules |
| **Build / Compilation** | Run the build command or check for TypeScript errors, import issues, missing dependencies |
| **Acceptance Criteria** | Map each criterion to observable behavior in the code — confirm it's satisfied or not |
| **Documentation** | Check that inline comments exist for complex logic, API docs are updated, README is current |

### Phase 3 — Present Verification Report

Follow `references/verification-report-template.md` exactly. Lead with the overall verdict so the user knows immediately whether the change is ready.

**If all checks pass:** the report is the final output — no further action needed from the skill.

**If any check fails:** report it, flag it clearly, and stop. Do not attempt to fix it.

---

## Verification Checklist (Quick Reference)

| Category | What to verify |
|----------|---------------|
| **Tests** | All existing tests pass; new tests added for new functionality; coverage is adequate for the change |
| **Lint** | No linting errors; code formatted to project standards |
| **Build** | Project builds successfully; no TypeScript/compilation errors; no new warnings |
| **Acceptance Criteria** | Each criterion is verifiably met; edge cases handled; error paths covered |
| **Documentation** | Inline comments for complex logic; API docs updated if endpoints changed; README current |

---

## Verdict Levels (Quick Reference)

| Verdict | Meaning |
|---------|---------|
| **Ready** | All checks pass; no blockers |
| **Ready with notes** | All checks pass; minor observations that don't block the PR |
| **Not Ready** | One or more checks failed; specific issues must be resolved before merging |

---

## Reference Files

| File | When to read |
|------|--------------|
| `references/verification-report-template.md` | Always — follow this format when presenting the verification report |
