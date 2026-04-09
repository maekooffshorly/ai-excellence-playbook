# Refactor — User Manual

A guide to cleaning up and restructuring code without changing behavior using the `refactor` skill.

---

## What It Does

The `refactor` skill reads your target code, identifies what needs to change and why, and presents a diff-based refactoring plan for your approval before touching anything. It applies the changes only after you confirm — and runs your tests immediately after to verify behavior was preserved.

It never adds functionality. It never changes behavior.

---

## Adding the Skill to a Project

The skill lives in the playbook repo under `skills/refactor/`. To use it in a project, copy it into that project's Claude configuration.

### Step 1 — Copy the skill folder

**Option A — Global level** *(available in every project on your machine — recommended)*

```
~/.claude/skills/
└── refactor/
    ├── SKILL.md
    └── references/
        └── refactoring-plan-template.md
```

On Windows: `C:\Users\{your-username}\.claude\skills\`

**Option B — Project-level** *(available only in that specific project)*

```
your-project/
└── .claude/skills/
    └── refactor/
        ├── SKILL.md
        └── references/
            └── refactoring-plan-template.md
```

### Step 2 — Confirm Claude Code sees it

Open Claude Code and type `/` — you should see `refactor` listed. If it doesn't appear, restart the Claude Code session.

---

## How to Invoke It

You don't need to type a command. Point at messy code and the skill auto-triggers.

**Phrases that automatically invoke the skill:**

| What you say | Triggers? |
|---|---|
| "Refactor this function" | ✅ |
| "Clean this up before the PR" | ✅ |
| "Too much duplication here" | ✅ |
| "This is too complex — simplify it" | ✅ |
| "Extract this into a helper" | ✅ |
| "Rename this for clarity" | ✅ |
| "The function is too long, break it up" | ✅ |
| "Remove the dead code" | ✅ |
| "Simplify the conditionals" | ✅ |
| "Make this more readable" | ✅ |

You can also invoke explicitly with `/refactor` if you prefer.

> **Note:** If you want to refactor *and* add new behavior, do them separately. Implement first, then refactor. Mixing the two makes it impossible to verify behavior was preserved.

---

## What to Include in Your Request

| What to include | Why it helps |
|---|---|
| File path and function name | Scopes the refactor to exactly what needs cleaning |
| What specifically bothers you | "Too complex", "too long", "duplicated", "hard to read" — guides which type of refactor to apply |
| What must stay the same | If certain behavior is load-bearing, say so — the plan will explicitly preserve it |

**Minimal prompt (works fine):**
```
Refactor @app/services/subscriptions.py lines 45–80. Too complex.
```

**Full prompt (best results):**
```
Refactor the `calculate_proration` function in @app/services/subscriptions.py.
It's too long and hard to follow. Extract the day-counting logic into a helper.
The public signature must stay the same — it's called from billing_service.py.
```

---

## What Happens After You Invoke It

### Phase 1 — Read (automatic)

The skill reads the target code in full, checks the caller interface, reads the test file to establish the behavior contract, and searches for related code (existing helpers, duplicate patterns elsewhere).

### Phase 2 — Refactoring Plan (requires your approval)

The skill presents:

| Section | What you'll see |
|---------|----------------|
| Target | File, scope, refactor type |
| What will NOT change | Explicit behavior guarantees |
| Proposed changes | Diff for each change, with a one-line rationale |
| Risk assessment | Uncertainty about behavior preservation, if any |
| Considerations | Bugs found, related helpers to check, caveats |
| Verification | Test command to run after |

**The skill pauses here and waits for you.** Narrow the scope, choose a different approach, or flag behavior it didn't account for before approving.

### Phase 3 — Apply Changes (after your approval)

The skill applies the changes exactly as proposed — no additions, no scope creep. If tests can be run, it runs them immediately. If a test fails, it stops and reports — it will not modify the test to make it pass.

---

## Refactor Types

| Type | When to use |
|------|------------|
| **Extract function** | A block has a single, nameable responsibility and is making the parent too long |
| **Remove duplication** | The same logic appears in 2+ places with identical intent |
| **Rename for clarity** | A name doesn't communicate what the thing actually does |
| **Simplify conditionals** | Nested if/else that can be flattened with early returns or guard clauses |
| **Remove dead code** | Unused variables, functions, imports, unreachable branches |
| **Magic numbers → constants** | Literal values with meaning not communicated by the value itself |
| **Move responsibility** | Code that belongs in a different layer or module |

---

## What the Skill Will Not Do

- **Add new behavior.** Even small additions — a new parameter, a new branch — are outside scope.
- **Change public interfaces silently.** If a refactor would change a function's signature or move it to a different module, it's flagged explicitly as a breaking change.
- **Modify tests.** Tests define correct behavior. If a refactor breaks a test, the refactor is wrong — the skill stops and reports, rather than adjusting the test.
- **Expand scope.** "Clean up this function" does not authorize changes to the file, module, or callers.

---

## After the Refactor

1. Run your full test suite — the refactoring plan includes the specific command
2. If anything fails, check the Risk Assessment section from the plan
3. Run `/code-review` if you want a second opinion on the cleaned-up code before the PR
