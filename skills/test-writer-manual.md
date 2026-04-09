# Test Writer — User Manual

A guide to generating comprehensive, maintainable test suites using the `test-writer` skill.

---

## What It Does

The `test-writer` skill analyzes a target file or function, reads your existing test patterns, and generates tests covering happy paths, edge cases, negative cases, error handling, and any scenarios you specify. It presents a test plan for your approval before writing any files.

It writes to test files only. It will never modify production code.

---

## Adding the Skill to a Project

The skill lives in the playbook repo under `skills/test-writer/`. To use it in a project, copy it into that project's Claude configuration.

### Step 1 — Copy the skill folder

**Option A — Global level** *(available in every project on your machine — recommended)*

```
~/.claude/skills/
└── test-writer/
    ├── SKILL.md
    └── references/
        └── test-output-template.md
```

On Windows: `C:\Users\{your-username}\.claude\skills\`

**Option B — Project-level** *(available only in that specific project)*

```
your-project/
└── .claude/skills/
    └── test-writer/
        ├── SKILL.md
        └── references/
            └── test-output-template.md
```

### Step 2 — Confirm Claude Code sees it

Open Claude Code and type `/` — you should see `test-writer` listed. If it doesn't appear, restart the Claude Code session.

> **Note:** Claude Code also ships a built-in `/test` command. The `test-writer` skill differs in that it reads your project's existing test conventions before generating, presents a plan for approval, and follows structured coverage categories. Use whichever fits your workflow.

---

## How to Invoke It

You don't need to type a command. Describe what you want and the skill auto-triggers.

**Phrases that automatically invoke the skill:**

| What you say | Triggers? |
|---|---|
| "Write tests for @app/services/subscriptions.py" | ✅ |
| "Add test coverage before I open the PR" | ✅ |
| "I just finished the feature — can you write tests?" | ✅ |
| "TDD — write tests for this function first" | ✅ |
| "Cover the happy paths and edge cases for Task-155" | ✅ |
| "Are my tests complete? Am I missing anything?" | ✅ |
| "Is this test correct?" | ✅ |
| "Add tests for the error handling paths" | ✅ |

You can also invoke explicitly with `/test-writer` if you prefer.

---

## What to Include in Your Request

| What to include | Why it helps |
|---|---|
| File path and line range (`@path/to/file.py lines 45–210`) | Focuses the skill on the exact code to test |
| Function or method names | Scopes coverage to specific units |
| Ticket reference (Jira, Linear, GitHub issue) | Lets the skill map acceptance criteria to test scenarios |
| Specific scenarios to cover | e.g. "missing tokens", "database errors", "invalid tier value" |
| "Catch-all for unexpected behavior" | Signals you want a defensive catch-all test |

**Minimal prompt (works fine):**
```
Write tests for @app/services/subscriptions.py lines 45–210.
```

**Full prompt (best results):**
```
Write tests for @app/services/subscriptions.py lines 45–210.
Reference Jira ticket Task-155.
Cover: happy paths, missing headers/tokens, invalid tier value,
database errors (simulate possible exceptions), and a catch-all
for unexpected behavior. Include edge cases I might have missed.
```

---

## What Happens After You Invoke It

### Phase 1 — Research (automatic)

The skill reads the target code, finds your existing test files to extract naming conventions and mocking patterns, fetches acceptance criteria from a ticket if referenced, and runs SonarQube to identify any existing issues that need explicit coverage.

### Phase 2 — Test Plan (requires your approval)

The skill presents:

| Section | What you'll see |
|---------|----------------|
| Target code | Files, line ranges, functions being tested |
| Coverage summary | Count per category (happy paths, edge cases, etc.) |
| Test code | Draft tests following your project's conventions |
| Considerations | Assumptions, mocking decisions, gaps worth noting |

**The skill pauses here and waits for you.** Review the plan — add scenarios, remove tests, or adjust scope before the skill writes anything to disk.

### Phase 3 — Write Tests (after your approval)

Once you confirm, the skill writes the test files to their correct locations. If it can run them, it will and report results. If any test reveals a production bug, it flags it — it will not fix production code.

---

## Coverage Categories

| Category | What gets tested |
|----------|-----------------|
| **Happy paths** | Normal execution with valid inputs |
| **Edge cases** | Boundary values, empty inputs, maximum limits |
| **Negative cases** | Invalid inputs, missing required fields, malformed data |
| **Error handling** | Expected exceptions, database failures, timeouts, permission denied |
| **State transitions** | Before/after states for operations that mutate data |
| **Security paths** | Auth failures, injection — critical modules only |

---

## What the Skill Will Not Do

- **Modify production code.** If a test reveals a bug, it documents it and stops. Fixing is your job.
- **Add tests beyond the agreed scope.** If it identifies gaps, it surfaces them in Considerations — it won't silently expand coverage.
- **Write integration tests by default.** It proposes them separately when cross-boundary coverage is genuinely needed.

---

## After the Tests Are Written

1. Run your test suite and verify the new tests pass
2. If any fail due to a bug in production code: fix the production code, then re-run
3. Run `/code-review` on the test files to verify coverage quality before opening a PR
