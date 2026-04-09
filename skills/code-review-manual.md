# Code Review — User Manual

A guide to getting structured, pre-PR code reviews using the `code-review` skill.

---

## What It Does

The `code-review` skill performs a structured review of your code changes before a PR is created or before merging to staging. It evaluates correctness, edge cases, security, performance, test coverage, and consistency against codebase patterns — and returns findings classified by severity so you know exactly what must be fixed vs. what's optional.

It is read-only. It will never modify your code.

---

## Adding the Skill to a Project

The skill lives in the playbook repo under `skills/code-review/`. To use it in a project, copy it into that project's Claude configuration.

### Step 1 — Copy the skill folder

**Option A — Global level** *(available in every project on your machine — recommended)*

```
~/.claude/skills/
└── code-review/
    ├── SKILL.md
    └── references/
        └── review-output-template.md
```

On Windows: `C:\Users\{your-username}\.claude\skills\`

> Use this option if you want code review available in every project without per-project setup.

**Option B — Project-level** *(available only in that specific project)*

```
your-project/
└── .claude/skills/
    └── code-review/
        ├── SKILL.md
        └── references/
            └── review-output-template.md
```

### Step 2 — Confirm Claude Code sees it

Open Claude Code and type `/` — you should see `code-review` listed. If it doesn't appear, restart the Claude Code session.

---

## How to Invoke It

You don't need to type a command. Describe what you want and the skill auto-triggers.

**Phrases that automatically invoke the skill:**

| What you say | Triggers? |
|---|---|
| "Review my code before I open a PR" | ✅ |
| "Can you check these changes?" | ✅ |
| "Pre-PR review on BL-107" | ✅ |
| "Is this ready to merge?" | ✅ |
| "Take a look at subscriptions.py — anything wrong?" | ✅ |
| "Does this match the codebase patterns?" | ✅ |
| "Check my test coverage" | ✅ |
| "Is there anything I missed?" | ✅ |

You can also invoke it explicitly with `/code-review` if you prefer.

---

## What to Include in Your Request

The more context you provide, the more actionable the review:

| What to include | Why it helps |
|---|---|
| File paths (`@path/to/file.py`) | Focuses the review on what actually changed |
| Line ranges | Narrows scope for large files |
| Ticket reference (Jira, Linear, GitHub issue) | Lets the skill verify acceptance criteria are met |
| Specific concerns | e.g. "focus on the auth logic" or "I'm worried about N+1 queries" |

**Minimal prompt (works fine):**
```
Review my changes before I open a PR.
Files: @app/services/subscriptions.py, @app/api/routes/subscriptions.py
```

**Full prompt (best results):**
```
Pre-PR review for BL-107.
Changed files: @app/services/subscriptions.py, @app/api/routes/subscriptions.py, @app/core/auth.py
Test files: @app/tests/test_subscriptions.py
Focus on the auth changes and check for edge cases in the subscription logic.
```

---

## What Happens After You Invoke It

### Phase 1 — Research (automatic)

The skill reads your changed files, pulls acceptance criteria from a ticket if referenced, checks how the changed code interacts with the rest of the codebase, runs SonarQube for static analysis, and evaluates the test files against what changed.

### Phase 2 — Review (requires your response)

The skill presents a structured review including:

| Section | What you'll see |
|---------|----------------|
| Summary | What was changed, overall verdict |
| Files reviewed | Status per file |
| Findings | Classified by severity (🔴 Critical → 🟢 Praise) |
| Acceptance criteria check | Pass/fail per requirement (if ticket provided) |
| Test coverage assessment | Gaps and quality notes |
| Recommendations | Prioritized action list |

**The skill pauses here and waits for you.** You can ask follow-up questions, dispute a finding, or provide additional context before finalizing.

### Phase 3 — Iteration

Respond with any questions or corrections. The skill will refine its findings and re-present the relevant sections. This continues until you're satisfied with the review.

---

## Severity Levels

| Severity | Icon | Meaning | What to do |
|----------|------|---------|------------|
| Critical | 🔴 | Bugs, security issues, data loss risk | Fix before merge |
| Major | 🟠 | Logic issues, missing validation, poor patterns | Fix before merge |
| Minor | 🟡 | Style inconsistencies, small improvements | Fix if time permits |
| Suggestion | 🔵 | Nice-to-haves, future improvements | Consider for later |
| Praise | 🟢 | Well-written code, good patterns | No action needed |

---

## What the Skill Will Not Do

- **Fix code.** It only reviews. If you want fixes, use the `build-fix` skill for errors or the `test-writer` skill for coverage gaps.
- **Approve PRs on your behalf.** The verdict in the review is guidance — the merge decision is yours.
- **Review the entire codebase.** Scope your request to the files that changed.

---

## After the Review

Once you've addressed the findings:

1. Run `/verify` to confirm tests pass, lint is clean, and acceptance criteria are met
2. Open the PR
