# Verify — User Manual

A guide to running a structured verification pass before opening a PR using the `verify` skill.

---

## What It Does

The `verify` skill runs a structured pre-PR checklist — tests, lint, build, acceptance criteria, and documentation — and produces a clear pass/fail report with a final verdict. It tells you whether the change is ready to ship and calls out exactly what needs fixing if not.

It is read-only. It will never modify your code, tests, or configuration.

---

## Adding the Skill to a Project

The skill lives in the playbook repo under `skills/verify/`. To use it in a project, copy it into that project's Claude configuration.

### Step 1 — Copy the skill folder

**Option A — Global level** *(available in every project on your machine — recommended)*

```
~/.claude/skills/
└── verify/
    ├── SKILL.md
    └── references/
        └── verification-report-template.md
```

On Windows: `C:\Users\{your-username}\.claude\skills\`

**Option B — Project-level** *(available only in that specific project)*

```
your-project/
└── .claude/skills/
    └── verify/
        ├── SKILL.md
        └── references/
            └── verification-report-template.md
```

### Step 2 — Confirm Claude Code sees it

Open Claude Code and type `/` — you should see `verify` listed. If it doesn't appear, restart the Claude Code session.

---

## How to Invoke It

You don't need to type a command. Describe what you want and the skill auto-triggers.

**Phrases that automatically invoke the skill:**

| What you say | Triggers? |
|---|---|
| "Is this ready for PR?" | ✅ |
| "Verify my implementation for AUTH-042" | ✅ |
| "Run the checks before I open a PR" | ✅ |
| "Does this meet the acceptance criteria?" | ✅ |
| "Make sure nothing broke after the refactor" | ✅ |
| "Pre-PR checklist" | ✅ |
| "I'm done — check everything" | ✅ |
| "Is this ready to ship?" | ✅ |

You can also invoke explicitly with `/verify` if you prefer.

---

## What to Include in Your Request

| What to include | Why it helps |
|---|---|
| Ticket reference (Jira, Linear, GitHub issue) | The skill uses acceptance criteria as the verification baseline — without them, AC checks are skipped |
| File paths (`@path/to/file.py`) | Scopes the verification to what actually changed |
| Specific concerns | e.g. "focus on the edge cases in the payment flow" or "check the TypeScript types" |

**Minimal prompt (works fine):**
```
Is this ready for PR? Ticket: AUTH-042
```

**Full prompt (best results):**
```
Verify implementation for AUTH-042 before I open the PR.
Changed: @app/api/routes/auth.py, @app/services/auth_service.py
Check tests, lint, build, and all acceptance criteria.
I'm especially unsure about the token expiry edge case.
```

---

## What Happens After You Invoke It

### Phase 1 — Research (automatic)

The skill reads the changed files, fetches acceptance criteria from the ticket if referenced, locates the corresponding test files, and assesses the scope of what needs verifying.

### Phase 2 — Run Checks (automatic)

The skill works through each category:

| Check | What's verified |
|-------|----------------|
| **Tests** | All existing tests pass; new tests added for new functionality |
| **Lint** | No linting errors; code formatted to project standards |
| **Build** | Builds successfully; no TypeScript or compilation errors |
| **Acceptance Criteria** | Each criterion mapped to observable behavior in the code |
| **Documentation** | Inline comments for complex logic; API docs updated if needed |

When possible, it runs commands directly. When not, it inspects the code and notes that manual verification is needed.

### Phase 3 — Verification Report

The skill presents a structured report with a clear overall verdict at the top, then per-category results, then specific issues with suggested fixes.

---

## Verdict Levels

| Verdict | Meaning | What to do |
|---------|---------|------------|
| **Ready** | All checks pass | Open the PR |
| **Ready with notes** | All checks pass; minor non-blocking observations | Open the PR; consider follow-up tickets for the notes |
| **Not Ready** | One or more checks failed | Fix the blockers, then re-run verify |

---

## If Checks Fail

The skill reports what failed and points to the right skill for resolution:

| Failure type | Suggested next step |
|---|---|
| Build errors | `build-fix` skill |
| Missing tests | `test-writer` skill |
| Documentation gaps | `docs` skill |
| Logic doesn't meet AC | Fix in your codebase, then re-run verify |

---

## What the Skill Will Not Do

- **Fix anything.** It reports — it doesn't touch code, tests, or config.
- **Pretend a check passed.** If it can't run a command directly, it says so and marks the check as needing manual confirmation.
- **Verify without defined acceptance criteria.** If no ticket is provided and no criteria are given, it skips the AC check and flags the gap.

---

## Where Verify Fits in the Pipeline

```
test-writer → docs → code-review → security-check → verify → PR
```

Verify is the final gate before the PR opens. All other skills should have run first.
